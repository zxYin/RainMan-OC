//
//  AppMediator+LKLoginModule.h
//  LKMediator
//
//  Created by Yunpeng on 16/9/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "LKNetworking.h"
@interface AppMediator (LKLoginModule)
- (YLBaseAPIManager *)LKLogin_loginAPIManager;
- (YLBaseAPIManager *)LKLogin_logoutAPIManager;
- (YLBaseAPIManager *)LKLogin_registerAPIManager;
- (void)LKLogin_presentLoginViewControllerWithSuccess:(void(^)())block animation:(BOOL)animation;
- (void)LKLogin_presentLoginViewControllerWithMessage:(NSString *)message success:(void(^)())block animation:(BOOL)animation;

@end
