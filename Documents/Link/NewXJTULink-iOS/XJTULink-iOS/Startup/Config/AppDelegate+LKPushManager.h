//
//  AppDelegate+LKPushManager.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate (LKPushManager)
- (void)LKPush_setupWithOptions:(NSDictionary *)launchOptions;
- (void)LKPush_didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end
