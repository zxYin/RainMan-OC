//
//  YLAPIBaseManager.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLResponseModel.h"
@class YLBaseAPIManager;
extern NSString * const kYLAPIBaseManagerRequestId;

// For transfer data
@protocol YLAPIManagerDataReformer <NSObject>
@required
- (id)apiManager:(YLBaseAPIManager *)manager reformData:(NSDictionary *)data;
@end

typedef NS_ENUM (NSUInteger, YLRequestType){
    YLRequestTypeGet,
    YLRequestTypePost,
};

typedef NS_ENUM (NSInteger, YLAPIManagerResponseStatus){
    YLAPIManagerResponseStatusDefault               = -1,     // 没有产生过API请求，默认状态。
    YLAPIManagerResponseStatusTimeout               = 101,    // 请求超时
    YLAPIManagerResponseStatusNoNetwork             = 102,    // 网络不通
    YLAPIManagerResponseStatusNoAccounts            = 103,    // 无帐号记录，需登录
    YLAPIManagerResponseStatusSuccess               = 200,    // API请求成功且返回数据正确
    YLAPIManagerResponseStatusParsingError          = 201,    // API请求成功但返回数据不正确
    YLAPIManagerResponseStatusEntityNotExist        = 203,    // 实体不存在
    YLAPIManagerResponseStatusCustomWebPage         = 204,    // 跳转至指定网页
    YLAPIManagerResponseStatusServerMessage         = 205,    // 服务器自定义消息
    YLAPIManagerResponseStatusTokenExpired          = 300,    // token过期
    YLAPIManagerResponseStatusLibPasswordError      = 301,    // 图书馆密码错误
    YLAPIManagerResponseStatusLoginForced           = 302,    // 强制登录
    YLAPIManagerResponseStatusRequestError          = 400,    // 请求出错，参数或方法错误
    YLAPIManagerResponseStatusServerNetworkError    = 401,    // 服务器网络错误
    YLAPIManagerResponseStatusPermissionDeny        = 402,    // 无权限
    YLAPIManagerResponseStatusMethodNotImplement    = 404,    // 方法未实现
    YLAPIManagerResponseStatusServerCrash           = 500,    // 服务器出错
    
};

@protocol YLAPIManager <NSObject>
@required
- (NSString *)path;
- (NSString *)apiVersion;
- (BOOL)isAuth;
@optional
- (NSString *)keyOfResult;
- (YLRequestType)requestType;
- (BOOL)isResponseJSONable;
- (BOOL)isRequestUsingJSON;

- (BOOL)shouldCache;
- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期
@end

@protocol YLAPIManagerDataSource <NSObject>
@required
- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager;
@end

@protocol YLAPIManagerDelegate <NSObject>
@required
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager;
- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error;

@optional
- (void)apiManagerLoadDidCancel:(YLBaseAPIManager *)apiManager;
/// 仅在不含有除TokenRefresher以外的依赖的情况下有效
- (void)apiManagerLoadPreviousDataSuccess:(YLBaseAPIManager *)apiManager;
@end



@protocol YLAPIManagerInterceptor <NSObject>
@optional
- (BOOL)apiManager:(YLBaseAPIManager *)manager beforePerformSuccessWithResponseModel:(YLResponseModel *)responsemodel;
- (void)apiManager:(YLBaseAPIManager *)manager afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel;

- (BOOL)apiManager:(YLBaseAPIManager *)manager beforePerformFailWithResponseError:(YLResponseError *)error;
- (void)apiManager:(YLBaseAPIManager *)manager afterPerformFailWithResponseError:(YLResponseError *)error;

- (void)afterPerformCancel:(YLBaseAPIManager *)manager;

- (BOOL)apiManager:(YLBaseAPIManager *)manager shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)apiManager:(YLBaseAPIManager *)manager afterLoadRequestWithParams:(NSDictionary *)params;
@end



@interface YLBaseAPIManager : NSObject

// 供debug下使用
//@property (nonatomic, assign) BOOL development;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, readonly) dispatch_semaphore_t continueMutex;

@property (nonatomic, weak) id<YLAPIManagerDataSource> dataSource;
@property (nonatomic, weak) id<YLAPIManagerDelegate> delegate;
@property (nonatomic, weak) id<YLAPIManagerInterceptor> interceptor;

@property (nonatomic, assign) NSUInteger requestCount;
@property (nonatomic, assign) NSTimeInterval requestTimestamp;

// addDependency和removeDependency仅在loadData前执行有效
- (void)addDependency:(YLBaseAPIManager *)apiManager;
- (void)removeDependency:(YLBaseAPIManager *)apiManager;


- (NSInteger)loadData;
- (NSInteger)loadDataWithoutCache;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (BOOL)isReachable;

- (id)fetchData;
- (id)fetchDataWithReformer:(id<YLAPIManagerDataReformer>)reformer;
- (id)fetchDataFromModel:(Class)clazz; //默认只实现单个model，且对应model字段为data，否则需重写这个方法

- (NSDictionary *)reformParams:(NSDictionary *)params;

// default
- (NSString *)host;
- (YLRequestType)requestType;   //default is YLRequestTypePost;
- (BOOL)isResponseJSONable;     //default is YES;
- (BOOL)isRequestUsingJSON;     //default is YES;

- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期


#pragma mark - 拦截器
// 用于子类需要监听相关事件，覆盖时需调用super对应方法
- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel;
- (void)afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel;

- (BOOL)beforePerformFailWithResponseError:(YLResponseError *)error;
- (void)afterPerformFailWithResponseError:(YLResponseError *)error;

- (void)afterPerformCancel;

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)afterLoadRequestWithParams:(NSDictionary *)params;

#pragma mark - 校验
// 需要校验则重写此方法
- (BOOL)isResponseDataCorrect:(YLResponseModel *)reponseModel;



+ (YLResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(YLAPIManagerResponseStatus)status
                                message:(NSString *)message;
@end
