//
//  AppDelegate+Statistics.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppDelegate+LKStatisticsManager.h"
#import "UMMobClick/MobClick.h"
#import "Foundation+LKTools.h"
#import "User.h"



@implementation AppDelegate (LKStatisticsManager)
- (void)LKStatistics_setupWithOptions:(NSDictionary *)launchOptions {
    [self setupUMeng];
}

// 友盟等统计SDK基本设置
- (void)setupUMeng {
    UMConfigInstance.appKey = UMengAppKey;
    
    [MobClick setAppVersion:AppVersion];
    NSString *userId = [User sharedInstance].userId;
    if ([NSString notBlank:userId]) {
        [MobClick profileSignInWithPUID:userId];
    }
    [MobClick setEncryptEnabled:YES];
    
#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)setupMoreStatistics {
    
}


@end
