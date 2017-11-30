//
//  AppDelegate.m
//  XJTUIn
//
//  Created by 李云鹏 on 15/3/23.
//  Copyright (c) 2015年 李云鹏. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "AppDelegate+LKStatisticsManager.h"
#import "AppDelegate+LKPushManager.h"

#import "AppMediator.h"
#import "LKShareManager.h"

#import "YLTokenRefresher.h"
#import "TBActionSheet.h"

#import "User+Persistence.h"
#import "Macros.h"
#import "NSUserDefaults+LKTools.h"
#import "SVProgressHUD.h"
#import "AppMediator+LKLoginModule.h"
#import "LKStatistics.h"
#import "LKShareManager.h"
#import "LKNoticeManager.h"
#import "Foundation+LKTools.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AppDelegate+Patch.h"
#import "SAMKeychain.h"

@interface AppDelegate () {
    WKWebView *_webView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [LKStatistics setup];
    [self setupJSPatch];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:  UIUserNotificationTypeAlert
                                                      | UIUserNotificationTypeBadge
                                                      | UIUserNotificationTypeSound
                                           categories:nil]];
        
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    /// 设置统计
    [self LKStatistics_setupWithOptions:launchOptions];
    
    /// 设置推送
    [self LKPush_setupWithOptions:launchOptions];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    
    if ([LKUserDefaults boolForKey:LKUserDefaultsFirstLaunch defaultValue:YES]) {
        NSLog(@"第一次启动");
        
        
        [LKUserDefaults setBool:NO forKey:LKUserDefaultsFirstLaunch];
    }
    
    [self setupNavigationAndTabBar];
    [self setupWebViewUserAgent];
    [self setupActionSheet];
    
    if ([LKUserDefaults boolForKey:LKUserDefaultsForceLogin defaultValue:YES]) {
        if (![User isLogined]) {
            execute_after_launching_on_main_queue(^{
                [[AppMediator sharedInstance] LKLogin_presentLoginViewControllerWithSuccess:nil animation:YES];
            });
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    [LKUserDefaults setObject:token forKey:LKUserDefaultsDeviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self LKPush_didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[LKShareManager sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    return [[AppMediator sharedInstance] performActionWithURL:url];
}


#pragma mark - 初始化导航栏
- (void)setupWebViewUserAgent {
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString *oldAgent, NSError * _Nullable error) {
        NSString *newAgent = [NSString stringWithFormat:@"XJTULink/%@ %@",AppVersion, oldAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        _webView = nil;
    }];
}

- (void)setupNavigationAndTabBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    [appearance setTranslucent:NO];
    [appearance setTintColor:[UIColor whiteColor]];
    [appearance setTitleTextAttributes:
        @{
          NSForegroundColorAttributeName:[UIColor whiteColor],
    }];
    
    [appearance setBarTintColor:LKColorLightBlue];
    [appearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage new]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{
       NSFontAttributeName : [UIFont boldSystemFontOfSize:11],
       } forState:UIControlStateNormal];
    
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTintColor:LKColorLightBlue];
}



- (void)setupActionSheet {
    TBActionSheet *appearance = [TBActionSheet appearance];
    appearance.buttonHeight = 44;
    appearance.rectCornerRadius = 0;
    appearance.separatorColor = [LKColorGray colorWithAlphaComponent:0.4];
    appearance.backgroundTransparentEnabled = NO;
    appearance.blurEffectEnabled = YES;
    appearance.offsetY = 0;
    appearance.buttonFont = [UIFont systemFontOfSize:16];
    appearance.sheetWidth = [UIScreen mainScreen].bounds.size.width;
}



- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%@",shortcutItem.type);
    [[AppMediator sharedInstance] performActionWithURL:[NSURL URLWithString:shortcutItem.type]];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    [[AppMediator sharedInstance] performActionWithURL:
     [NSURL URLWithString:userInfo[kLocalNotificationURL]]];
}


@end
