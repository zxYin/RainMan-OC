//
//  AppDelegate+LKPushManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppDelegate+LKPushManager.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "User.h"
#import "NSDictionary+LKValueGetter.h"
#import "AppMediator+LKNewsModule.h"

@interface AppDelegate (_LKPushManager)<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (LKPushManager)

- (void)LKPush_setupWithOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:UMengPushAppKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    NSString *userId = [User sharedInstance].userId;
    if ([NSString notBlank:userId]) {
        [UMessage addAlias:userId type:AppScheme response:^(id responseObject, NSError *error) {
            NSLog(@"[UMessage]确认别名");
        }];
    }

#if DEBUG
    [UMessage setLogEnabled:YES];
    [UMessage openDebugMode:YES];
#endif
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types =
        UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogin object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if([NSString notBlank:[note.object safeType:[NSString class]]]) {
            [UMessage addAlias:note.object type:AppScheme response:^(id responseObject, NSError *error) {
                NSLog(@"[LKPushManager]确认别名:%@",note.object);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if([NSString notBlank:[note.object safeType:[NSString class]]]) {
            [UMessage removeAlias:note.object type:AppScheme response:^(id responseObject, NSError *error) {
                NSLog(@"[LKPushManager]取消别名");
            }];
        }
    }];
}


- (void)LKPush_didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSURL *url = [userInfo URLForKey:@"native_url"];
    NSString *module = [userInfo stringForKey:@"module"];
    NSString *path = [userInfo stringForKey:@"path"];
    if (url) {
        [[AppMediator sharedInstance] performActionWithURL:url];
    } else if([NSString notBlank:module]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@",AppScheme, module, path?:@""]];
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        params[@"module"] = nil;
        params[@"path"] = nil;
        params[@"aps"] = nil; // 去除友盟无用的参数
        NSDictionary *originalQueryString = [NSDictionary dictionaryWithURLQueryString:url.query];
        [params addEntriesFromDictionary:originalQueryString];
        components.query = [params URLQueryStringWithoutEncoding];
        if (components.URL) {
            [[AppMediator sharedInstance] performActionWithURL:components.URL];
        }
    }
}

@end
