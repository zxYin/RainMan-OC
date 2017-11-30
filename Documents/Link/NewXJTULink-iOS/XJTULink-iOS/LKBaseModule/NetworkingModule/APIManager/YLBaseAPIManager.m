//
//  YLAPIBaseManager.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"
#import "YLAPIProxy.h"
#import <Mantle/Mantle.h>
#import "YLCacheProxy.h"
#import "YLAuthParamsGenerator.h"
#import "YLTokenRefresher.h"
#import "AppContext.h"
#import "Foundation+LKTools.h"
#import "LKWebBrowser.h"
#import "NSDictionary+LKValueGetter.h"
#import "LKUpdateViewController.h"
#import <libkern/OSAtomic.h>
#import "AppMediator.h"
#import "AppMediator+LKLoginModule.h"

NSString * const kYLAPIBaseManagerRequestId = @"xyz.ypli.kYLAPIBaseManagerRequestID";

#define YLLoadRequest(REQUEST_METHOD, REQUEST_ID)                                                  \
{\
__weak typeof(self) weakSelf = self;\
\
\
REQUEST_ID = [[YLAPIProxy sharedInstance] load##REQUEST_METHOD##WithParams:finalAPIParams useJSON:self.isRequestUsingJSON host:self.host path:self.child.path apiVersion:self.child.apiVersion success:^(YLResponseModel *response) {\
__strong typeof(weakSelf) strongSelf = weakSelf;\
[strongSelf dataDidLoad:response];\
} fail:^(YLResponseError *error) {\
__strong typeof(weakSelf) strongSelf = weakSelf;\
[strongSelf dataLoadFailed:error];\
}];\
self.requestIdMap[@(REQUEST_ID)]= @(REQUEST_ID);\
}\


static void thread_safe_execute(dispatch_block_t block) {
    static OSSpinLock yl_networking_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&yl_networking_lock);
    block();
    OSSpinLockUnlock(&yl_networking_lock);
}

@interface YLBaseAPIManager() {
    BOOL forceUpdate;
}
@property (nonatomic, assign, readonly) NSUInteger createTime;
@property (nonatomic, assign) NSUInteger errorCount;
@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, strong, readwrite) id rawData;
//@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;
@property (nonatomic, strong) NSMutableSet *dependencySet;


// 业务层得到的requestId 与 APIProxy得到的requsetId是不同的，这里即保存着他们的对应关系
// 之所以这么设计是为了在网络层重新发起请求的时候，让业务层是不可感知。
@property (nonatomic, strong) NSMutableDictionary *requestIdMap;

@property (nonatomic, weak) YLBaseAPIManager<YLAPIManager>* child;

@end
@implementation YLBaseAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YLAPIManager)]) {
            self.child = (id <YLAPIManager>)self;
            _createTime = (NSUInteger)[NSDate timeIntervalSinceReferenceDate];
            _requestTimestamp = -1;
            _continueMutex = dispatch_semaphore_create(0);
            _dependencySet = [NSMutableSet set];
            _requestIdMap = [NSMutableDictionary dictionary];
            _requestCount = 0;
            _errorCount = 0;
            _isReload = 0;
            forceUpdate = NO;
        } else {
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ init failed",[self class]]
                                           reason:@"Subclass of YLAPIBaseManager should implement <YLAPIManager>"
                                         userInfo:nil];
        }
    }
    return self;
}

- (NSUInteger)hash {
    return [self.class hash] ^ self.createTime;
}

- (NSString *)host {
    return kServerURL;
}

- (YLRequestType)requestType {
    return YLRequestTypePost;
}

- (BOOL)isResponseJSONable {
    return YES;
}

- (BOOL)isRequestUsingJSON {
    return YES;
}

- (BOOL)shouldCache {
    return kYLShouldCacheDefault;
}

- (NSInteger)cacheExpirationTime {
    return kYLCacheExpirationTimeDefault;
}

- (BOOL)isReachable {
    return [[YLAPIProxy sharedInstance] isReachable];
}

- (BOOL)isLoading {
//    if (self.requestIdMap.count == 0) {
//        _isLoading = NO;
//    }
    return _isLoading;
}

- (void)addDependency:(YLBaseAPIManager *)apiManager {
    if(apiManager == nil) return;
    // 此处用NSMutableSet而没用NSHash​Table
    // 是由于此处必须是强引用，以防止在此apiManager请求前，所依赖的apiManager被释放，而导致无法判断依赖的apiManager是否完成
    // 此处会导致被依赖的apiManager只能等待所有产生该依赖的apiManager被释放完后才能释放。
    thread_safe_execute(^{
        [self.dependencySet addObject:apiManager];
    });
}

- (void)removeDependency:(YLBaseAPIManager *)apiManager {
    if(apiManager == nil) return;
    thread_safe_execute(^{
        [self.dependencySet removeObject:apiManager];
    });
}

- (NSInteger)loadData {
    self.isLoading = YES;
    if (self.child.isAuth && kYLAutoRefreshToken) {
        // 在此给所有的需要认证信息的APIManager添加对YLTokenRefresher的依赖，利用AOP的形式用户无感知地刷新Token
        // 由于采用的是NSMutableSet，也无需担心重复添加的问题
        // 再者不用使用dispatch_once，以防止某些情况譬如动态更新时改掉isAuth时，无法正确添加依赖关系
        [self addDependency:[YLTokenRefresher sharedInstance]];
    }
    
    static NSInteger requestIndex = 0;
    
    __block NSInteger openRequestId;
    thread_safe_execute(^{
        requestIndex++;
        openRequestId = requestIndex;
    });
    
    [self waitForDependency:^{
        self.requestCount++;
        self.requestTimestamp = [[NSDate date] timeIntervalSince1970];
        NSDictionary *params = [self.dataSource paramsForAPI:self];
        NSInteger requestId = [self loadDataWithParams:params];
        self.requestIdMap[@(openRequestId)] = @(requestId);
        NSLog(@"===>%@",self.requestIdMap);
    }];
    return openRequestId;
}

- (NSInteger)loadDataWithoutCache {
//    self.shouldCache = NO;
    forceUpdate = YES;
    return [self loadData];
}

// 不将此方法开放出去是为了强制使用dataSource来提供数据，类同UITableView
- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    NSMutableDictionary *finalAPIParams = [[NSMutableDictionary alloc] init];
    if (apiParams) {
        [finalAPIParams addEntriesFromDictionary:apiParams];
    }
    
    if (self.child.isAuth) {
        NSDictionary *authParams = [YLAuthParamsGenerator authParams];
        if (authParams != nil) {
            [finalAPIParams addEntriesFromDictionary:authParams];
        } else {
            [self dataLoadFailed:
             [YLBaseAPIManager errorWithRequestId:requestId
                                           status:YLAPIManagerResponseStatusNoAccounts]];
            return requestId;
        }
    }
    
    if ([self shouldLoadRequestWithParams:finalAPIParams]) {
        if (!forceUpdate &&
            [self shouldCache] && [self tryLoadResponseFromCacheWithParams:finalAPIParams]) {
            return 0;
        }
        
        if ([[YLAPIProxy sharedInstance] isReachable]) {
            switch (self.child.requestType) {
                case YLRequestTypeGet:
                    YLLoadRequest(GET, requestId);
                    break;
                case YLRequestTypePost:
                    YLLoadRequest(POST, requestId);
                    break;
                default:
                    break;
            }
            
            NSMutableDictionary *params = [finalAPIParams mutableCopy];
            params[kYLAPIBaseManagerRequestId] = @(requestId);
            [self afterLoadRequestWithParams:params];
            return requestId;
        } else {
            [self dataLoadFailed:
             [YLBaseAPIManager errorWithRequestId:requestId
                                           status:YLAPIManagerResponseStatusNoNetwork]];
            return requestId;
        }
    }
    return requestId;
}



#pragma mark - api callbacks
- (void)dataDidLoad:(YLResponseModel *)responseModel {
    self.isLoading = NO;
    
    [self.requestIdMap removeObjectForKey:@(responseModel.requestId)];
    if ([self isResponseJSONable]) {
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseModel.responseData
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:&error];
        if (error != nil) {
            YLResponseError *error = [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                                                   status:YLAPIManagerResponseStatusParsingError];
            error.response = jsonDict;
            
            [self dataLoadFailed:error];
            return;
        }
        
        self.rawData = jsonDict;
        NSInteger status = [jsonDict[@"status"] integerValue];
        if (status != YLAPIManagerResponseStatusSuccess) {
            NSString *message = jsonDict[@"message"];
            if (status == YLAPIManagerResponseStatusServerMessage) {
                message = jsonDict[@"notice"];
            }
            YLResponseError *error = [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                                                   status:status
                                                                  message:message];
            error.response = jsonDict;
            [self dataLoadFailed:error];
            return;
        }
        if (!responseModel.isCache
            && [jsonDict[@"token_did_update"] boolValue]) {
            [[YLTokenRefresher sharedInstance] newUserTokenDidVerify];
        }
        
    } else {
        self.rawData = [responseModel.responseData copy];
    }
    
    if([self isResponseDataCorrect:responseModel]
       && [self beforePerformSuccessWithResponseModel:responseModel]) {
        NSLog(@"数据加载完毕");
        
        [self.delegate apiManagerLoadDataSuccess:self];
        
        if ([self shouldCache] && !responseModel.isCache) {
            [[YLCacheProxy sharedInstance] setCacheData:responseModel.responseData forParams:responseModel.requestParams.dictionaryExceptToken host:self.host path:self.child.path apiVersion:self.child.apiVersion withExpirationTime:self.child.cacheExpirationTime];
        }
        [self afterPerformSuccessWithResponseModel:responseModel];
        dispatch_semaphore_signal(self.continueMutex);
        self.isReload = NO;
    } else {
        [self dataLoadFailed:
         [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                       status:YLAPIManagerResponseStatusParsingError]];
    }
    forceUpdate = NO;
}

- (void)dataLoadFailed:(YLResponseError *)error {
//    self.isLoading = NO;
    
    // 将requestId更改为对外的requestId
    __block NSInteger openRequestId = 0;
    [self.requestIdMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj integerValue] == error.requestId) {
            openRequestId = [key integerValue];
        }
    }];
    NSDictionary *response = error.response;
    error = YLResponseError(error.message, error.code, openRequestId);
    error.response = response;
    
    if(error.code == YLResponseStatusCancel) {
        // 处理请求被取消
        if([self.delegate respondsToSelector:@selector(apiManagerLoadDidCancel:)]) {
            [self.delegate apiManagerLoadDidCancel:self];
        }
        [self afterPerformCancel];
        return;
    }
    self.errorCount++;
    
    if ([error.response[@"token_did_update"] boolValue]) {
        [[YLTokenRefresher sharedInstance] newUserTokenDidVerify];
    }
    
    
    if (self.child.isAuth
        && error.code == YLAPIManagerResponseStatusTokenExpired
        && kYLAutoRefreshToken) {
        if (self.requestTimestamp > [YLTokenRefresher sharedInstance].requestTimestamp) {
            // 当请求在Token刷新之后发出去的则告知YLTokenRefresher需要刷新
            // 否则代表Token已经在刷新或刷新完毕，则不再调用刷新Token
            [[YLTokenRefresher sharedInstance] needRefresh];
        }
        [self waitForDependency:^{
            if (!self.isReload) {
                // 重启访问
                self.requestIdMap[@(error.requestId)] = @([self loadData]);
                self.isReload = YES;
            }
        }];
        return;
    }
    
    // 强制登录
    if (error.code == YLAPIManagerResponseStatusLoginForced
        || error.code == YLAPIManagerResponseStatusNoAccounts) {
        [[AppMediator sharedInstance] LKLogin_presentLoginViewControllerWithMessage:error.message success:^{
            
        } animation:YES];
    }
    
    
    if ([self beforePerformFailWithResponseError:error]) {
        [self.requestIdMap removeObjectForKey:@(error.requestId)];
        
        // 显示来自服务器的自定义信息
        [self AOP_handleError:error];
        
        if ([self.delegate respondsToSelector:@selector(apiManager:loadDataFail:)]) {
            [self.delegate apiManager:self loadDataFail:error];
        }
        [self afterPerformFailWithResponseError:error];
    }
    forceUpdate = NO;
}

#pragma mark - AOP 处理相应的错误
- (void)AOP_handleError:(YLResponseError *)error {
    UINavigationController *navController = [[AppContext sharedInstance] currentNavigationController];
    switch (error.code) {
        case YLAPIManagerResponseStatusServerMessage: {
            [AppContext showAlertWithTitle:@"温馨提示" message:[error.response stringForKey:@"notice"]];
            break;
        }
        case YLAPIManagerResponseStatusCustomWebPage: {
            [navController popViewControllerAnimated:NO];
            NSURL *url = [error.response URLForKey:@"url"];
            NSString *title = [error.response stringForKey:@"title" defaultValue:@"临时通知"];
            if(url) {
                if ([url.scheme isEqualToString:AppScheme]) {
                    [[AppMediator sharedInstance] performActionWithURL:url];
                } else {
                    UIViewController *vc = [LKWebBrowser webBrowserWithURL:url title:title];
                    vc.hidesBottomBarWhenPushed = YES;
                    [navController pushViewController:vc animated:YES];
                }
            }
            break;
        }
        case YLAPIManagerResponseStatusMethodNotImplement: {
            [navController popViewControllerAnimated:NO];
            UIViewController *vc = [[LKUpdateViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:vc animated:YES];
            
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - public API
- (void)cancelAllRequests {
    [[YLAPIProxy sharedInstance] cancelRequestWithRequestIdList:self.requestIdMap.allValues];
    [self.requestIdMap removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestId {
    NSNumber *realRequstId = self.requestIdMap[@(requestId)];
    [self.requestIdMap removeObjectForKey:@(requestId)];
    [[YLAPIProxy sharedInstance] cancelRequestWithRequestId:realRequstId];
}

- (id)fetchData {
    return [self fetchDataWithReformer:nil];
}

- (id)fetchDataWithReformer:(id<YLAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(apiManager:reformData:)]) {
        resultData = [reformer apiManager:self reformData:self.rawData];
    } else {
        resultData = [self.rawData mutableCopy];
    }
    return resultData;
}

- (id)fetchDataFromModel:(Class)clazz {
    NSError *error;
    NSDictionary *json = [[self fetchData] dictionaryForKey:@"data"];
    if ([self.child respondsToSelector:@selector(keyOfResult)]) {
        json = [json dictionaryForKey:self.child.keyOfResult];
    }
    id model = [MTLJSONAdapter modelOfClass:clazz fromJSONDictionary:json error:&error];
    NSLog(@"Error:%@",error);
    return model;
}

#pragma mark - private API

- (void)waitForDependency:(dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (YLBaseAPIManager *apiManager in self.dependencySet) {
            NSLog(@"%@ wait %@",self, apiManager);
            dispatch_semaphore_wait(apiManager.continueMutex, DISPATCH_TIME_FOREVER);
            // 得到后立刻释放，防止其他请求无法进行
            NSLog(@"%@ Done",apiManager);
            dispatch_semaphore_signal(apiManager.continueMutex);
        }
        
        NSLog(@"block::::%@",block);
        if(block) {
            NSLog(@"执行block");
            block();
        }
    });
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)tryLoadResponseFromCacheWithParams:(NSDictionary *)params {
    NSData *cache = [[YLCacheProxy sharedInstance] cacheForParams:params.dictionaryExceptToken host:self.host path:self.child.path apiVersion:self.child.apiVersion];
    if (cache == nil) {
        return NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            YLResponseModel *responseModel = [[YLResponseModel alloc] initWithData:cache];
            [self dataDidLoad:responseModel];
        });
    });
    
    return YES;
}

#define YLResponseErrorWithMSG(MSG) YLResponseError(MSG, status, requestId)
+ (YLResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(YLAPIManagerResponseStatus)status {
    return [self errorWithRequestId:requestId status:status message:nil];
}

+ (YLResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(YLAPIManagerResponseStatus)status
                                message:(NSString *)message {
    switch (status) {
        case YLAPIManagerResponseStatusParsingError:
            return YLResponseErrorWithMSG(@"数据解析错误");
        case YLAPIManagerResponseStatusTimeout:
            return YLResponseErrorWithMSG(@"请求超时");
        case YLAPIManagerResponseStatusNoNetwork:
            return YLResponseErrorWithMSG(@"当前网络已断开");
        case YLAPIManagerResponseStatusNoAccounts:
            return YLResponseErrorWithMSG(@"(￣y▽￣)~*登个录吧");
        case YLAPIManagerResponseStatusEntityNotExist:
            return YLResponseErrorWithMSG(@"(╭￣3￣)╭你找的东西不存在了~");
        case YLAPIManagerResponseStatusServerMessage:
            return YLResponseErrorWithMSG(message?:@"未知消息");
        case YLAPIManagerResponseStatusTokenExpired:
            return YLResponseErrorWithMSG(@"token已过期");
        case YLAPIManagerResponseStatusLibPasswordError:
            return YLResponseErrorWithMSG(@"(╭￣3￣)╭图书馆帐号或密码错误");
        case YLAPIManagerResponseStatusLoginForced:
            return YLResponseErrorWithMSG(@"(┙>∧<)┙登录过期啦，请重新登录");
        case YLAPIManagerResponseStatusCustomWebPage:
            return YLResponseErrorWithMSG(@"临时跳转页面");
        case YLAPIManagerResponseStatusRequestError:
            return YLResponseErrorWithMSG(@"请求出错");
        case YLAPIManagerResponseStatusServerNetworkError:
            return YLResponseErrorWithMSG(@"(╬▔皿▔) 服务器发生一些情况，请过段时间再试");
        case YLAPIManagerResponseStatusMethodNotImplement:
            return YLResponseErrorWithMSG(@"方法未实现");
        case YLAPIManagerResponseStatusServerCrash:
            return YLResponseErrorWithMSG(@"o(￣ヘ￣*o) 服务器又出错了");
        default:
            return YLResponseErrorWithMSG(@"未知错误");
    }
}

#pragma mark -
- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformSuccessWithResponseModel:)]) {
        result = [self.interceptor apiManager:self beforePerformSuccessWithResponseModel:responseModel];
    }
    return result;
}
- (void)afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformSuccessWithResponseModel:)]) {
        [self.interceptor apiManager:self afterPerformSuccessWithResponseModel:responseModel];
    }
}

- (BOOL)beforePerformFailWithResponseError:(YLResponseError *)error {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformFailWithResponseError:)]) {
        result = [self.interceptor apiManager:self beforePerformFailWithResponseError:error];
    }
    return result;
}

- (void)afterPerformFailWithResponseError:(YLResponseError *)error {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformFailWithResponseError:)]) {
        [self.interceptor apiManager:self afterPerformFailWithResponseError:error];
    }
}

- (void)afterPerformCancel {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(afterPerformCancel:)]) {
        [self.interceptor afterPerformCancel:self];
    }
}

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:shouldLoadRequestWithParams:)]) {
        result = [self.interceptor apiManager:self shouldLoadRequestWithParams:params];
    }
    return result;
}

- (void)afterLoadRequestWithParams:(NSDictionary *)params {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterLoadRequestWithParams:)]) {
        [self.interceptor apiManager:self afterLoadRequestWithParams:params];
    }
}

#pragma mark - 校验器
// 这里不作实现，这样子类重写时，不需要调用super
- (BOOL)isResponseDataCorrect:(YLResponseModel *)reponseModel {
    return YES;
}
@end
