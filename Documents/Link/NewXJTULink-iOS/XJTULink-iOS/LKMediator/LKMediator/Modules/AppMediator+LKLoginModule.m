//
//  AppMediator+LKLoginModule.m
//  LKMediator
//
//  Created by Yunpeng on 16/9/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKLoginModule.h"
NSString * const kAppMediatorLoginModule= @"LKLoginModule";
NSString * const kAppMediatorLoginServiceLoginAPIManager = @"casLoginAPIManager";
NSString * const kAppMediatorLoginServiceLogoutAPIManager = @"logoutAPIManager";
NSString * const kAppMediatorLoginServiceRegisterAPIManager = @"registerAPIManager";
NSString * const kAppMediatorLoginServicePresentLoginViewController = @"presentLoginViewController";

@implementation AppMediator (LKLoginModule)
- (YLBaseAPIManager *)LKLogin_loginAPIManager {
    return [[self performAction:kAppMediatorLoginServiceLoginAPIManager
                       onModule:kAppMediatorLoginModule
                         params:nil] safeType:[YLBaseAPIManager class]];
}

- (YLBaseAPIManager *)LKLogin_logoutAPIManager {
    return [[self performAction:kAppMediatorLoginServiceLogoutAPIManager
                       onModule:kAppMediatorLoginModule
                         params:nil] safeType:[YLBaseAPIManager class]];
}

- (YLBaseAPIManager *)LKLogin_registerAPIManager {
    return [[self performAction:kAppMediatorLoginServiceRegisterAPIManager
                       onModule:kAppMediatorLoginModule
                         params:nil] safeType:[YLBaseAPIManager class]];
}

- (void)LKLogin_presentLoginViewControllerWithSuccess:(void(^)())block animation:(BOOL)animation {
    [self LKLogin_presentLoginViewControllerWithMessage:nil success:block animation:animation];
}

- (void)LKLogin_presentLoginViewControllerWithMessage:(NSString *)message success:(void(^)())block animation:(BOOL)animation {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"callback"] = [block copy];
    params[@"animation"] = @(animation);
    params[@"message"] = message;
    [self performAction:kAppMediatorLoginServicePresentLoginViewController
               onModule:kAppMediatorLoginModule
                 params:[params copy]];
}

@end
