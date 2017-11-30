//
//  YLTokenRefresher.m
//  YLNetworking
//
//  Created by Yunpeng on 16/8/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLTokenRefresher.h"

#import "YLAuthParamsGenerator.h"
#import "User+Persistence.h"
#import "Foundation+LKTools.h"
#import "AppMediator+LKLoginModule.h"
#import "AppContext.h"
#import "User+Auth.h"
#import "Macros.h"

@interface YLTokenRefresher()<YLAPIManagerDataSource, YLAPIManagerDelegate> {
    YLBaseAPIManager *_loginAPIManager;
}
@end

@implementation YLTokenRefresher
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
        if ([User isLogined]) {
            dispatch_semaphore_signal(self.continueMutex);
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dispatchSemaphoreSignal) name:LKNotificationUserDidLogin object:nil];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YLTokenRefresher *instance;
    dispatch_once(&onceToken, ^{
        instance = [YLTokenRefresher new];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            instance = [YLTokenRefresher new];
        }];
    });
    return instance;
}

- (NSString *)host {
    return kCASURL;
}

- (NSString *)path {
    return @"login";
}

- (NSString *)apiVersion {
    return @"";
}

- (BOOL)isAuth {
    // 这里一定是NO，否则会让TokenRefresher依赖自己从而产生死锁
    return NO;
}

- (BOOL)shouldCache {
    return NO;
}

- (BOOL)isResponseJSONable {
    return NO;
}

- (BOOL)isRequestUsingJSON {
    return NO;
}

- (NSInteger)loadData {
    self.isLoading = YES;
    dispatch_semaphore_wait(self.continueMutex, DISPATCH_TIME_FOREVER);
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - self.requestTimestamp < 60 * 5
        && self.requestCount > 2) {
        // 五分钟内触发重登录三次及以上就直接弹出登录框
        YLResponseError *error = [YLBaseAPIManager errorWithRequestId:-1 status:YLAPIManagerResponseStatusLoginForced message:@"login too frequently"];
        [self apiManager:nil loadDataFail:error];
        return -1;
    } else {
        // 超过五分钟，则将requestCount置为1
        self.requestCount = 1;
    }
    
    _loginAPIManager = [[AppMediator sharedInstance] LKLogin_loginAPIManager];
    _loginAPIManager.delegate = self;
    self.requestCount++;
    self.requestTimestamp = now;
    
    return [_loginAPIManager loadData];
}

- (void)newUserTokenDidVerify {
    [[User sharedInstance] newUserTokenDidVerify];
}

- (void)needRefresh {
    if (!self.isLoading
        &&
        !_loginAPIManager.isLoading) {
        // 防止无效cookie的影响
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        [self loadData];
    }
}


//#pragma mark - YLAPIManagerDataSource
//- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    if (manager == _registerAPIManager) {
//        params[@"kRegisterAPIManagerParamsKeyUserId"] = [User sharedInstance].userId;
//        params[@"kRegisterAPIManagerParamsKeyUserToken"] = [User sharedInstance].userTokenNoTimestamp;
//    }
//    return [params copy];
//}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    if (apiManager == _loginAPIManager) {
        self.isLoading = NO;
        [self dispatchSemaphoreSignal];
        _loginAPIManager = nil;
    }
    
}

- (void)dispatchSemaphoreSignal {
    dispatch_semaphore_signal(self.continueMutex);
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    NSString *message = [User isLogined]?error.message:nil;
    @weakify(self);
    [[AppMediator sharedInstance] LKLogin_presentLoginViewControllerWithMessage:message success:^{
        @strongify(self);
        self.isLoading = NO;
        [self dispatchSemaphoreSignal];
    } animation:YES];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
