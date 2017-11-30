//
//  CASLoginAPIManager.m
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CASLoginAPIManager.h"
#import "CASHTMLFetcher.h"
#import "OCGumbo+Query.h"
#import "Constants.h"
#import "Foundation+LKTools.h"
#import "User+Auth.h"
#import "User+Persistence.h"
#import "AppContext.h"
NSString * const kCASLoginAPIManagerParamsKeyNetId = @"kCASLoginAPIManagerParamsKeyNetId";
NSString * const kCASLoginAPIManagerParamsKeyPassword = @"kCASLoginAPIManagerParamsKeyPassword";

@interface CASLoginAPIManager()<YLAPIManagerDelegate> {
    CASHTMLFetcher *_casHTMLFetcher;
}
@end
@implementation CASLoginAPIManager

#pragma mark - YLAPIManager
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
    if ([NSString isBlank:[User sharedInstance].netId]
        ||[NSString isBlank:[User sharedInstance].password]) {
        YLResponseError *error = [YLBaseAPIManager errorWithRequestId:-1 status:YLAPIManagerResponseStatusLoginForced message:@"no password"];
        [self apiManager:nil loadDataFail:error];
        return -1;
    }
    
    _casHTMLFetcher = [CASHTMLFetcher new];
    _casHTMLFetcher.delegate = self;
    [self addDependency:_casHTMLFetcher];
    [_casHTMLFetcher loadData];
    return [super loadData];
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:6];
    
    NSString *html = [[NSString alloc] initWithData:[_casHTMLFetcher fetchData] encoding:NSUTF8StringEncoding];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:html];
    @try {
        [document.Query(@"input") enumerateObjectsUsingBlock:^(OCGumboElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            parameters[element.attr(@"name")] = element.attr(@"value")?:@"";
        }];
        parameters[@"username"] = [User sharedInstance].netId;
        parameters[@"password"] = [User sharedInstance].password;
    } @catch(NSException *e) {
        // 解析异常
        NSLog(@"[CASLoginAPIManager]解析异常:%@",e);
    }
    NSLog(@"[CASLoginAPIManager]%@",[parameters copy]);
    return [parameters copy];
}


- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    [super beforePerformSuccessWithResponseModel:responseModel];
    
    if (![responseModel.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return NO;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responseModel.response;
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:[NSURL URLWithString:@""]];
    NSString *newToken = nil;
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"cookie:%@",[cookie name]);
        if ([[cookie name] isEqualToString:@"CASTGC"]) {
            newToken = [cookie value];
            break;
        }
    }
    
    if ([NSString isBlank:newToken]) {
        return NO;
    }
    
    [[User sharedInstance] tryUpdateUserToken:newToken];
    [[[User sharedInstance].networkingRAC requestCommand] execute:nil];
    return YES;

}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    NSLog(@"%@ 请求成功",apiManager);
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    if (apiManager == _casHTMLFetcher) {
        if ([self beforePerformFailWithResponseError:error]) {
            if ([self.delegate respondsToSelector:@selector(apiManager:loadDataFail:)]) {
                [self.delegate apiManager:self loadDataFail:error];
            }
            [self afterPerformFailWithResponseError:error];
        }
    }
}
@end
