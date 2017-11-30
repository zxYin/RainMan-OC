//
//  LKPermissionManager.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKPermissionManager.h"
#import "LKPermissionDenyAlertView.h"
#import "AppContext.h"
#import "Macros.h"
#import "NSUserDefaults+LKTools.h"

@implementation LKPermissionManager
+ (void)load {
    if(![LKUserDefaults boolForKey:LKUserDefaultsFirstLaunch defaultValue:YES]
       && [LKUserDefaults boolForKey:LKUserDefaultsShouldCheckNoticationPermission defaultValue:YES]) {
        execute_after_launching_on_main_queue(^{
            [[LKPermissionManager sharedInstance] checkNotificationPermission];
        });
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKPermissionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKPermissionManager alloc] init];
    });
    return instance;
}


- (void)checkNotificationPermission {
    [self checkNotificationPermissionWithMessage:nil];
}

- (void)checkNotificationPermissionWithMessage:(NSString *)message {
    if (UIUserNotificationTypeNone !=
        [[UIApplication sharedApplication] currentUserNotificationSettings].types) {
        return;
    }
    
    NSString *title = @"通知权限出问题了";
    NSString *content = message?:@"通知权限未开放，您将无法收到图书到期、学校新闻、社区评论等推送信息。";
    [self showPermissionDenyWithTitle:title content:content];
}


- (void)showPermissionDenyWithTitle:(NSString *)title content:(NSString *)content {
    LKPermissionDenyAlertView *contentView =
    [LKPermissionDenyAlertView viewWithOpenBlock:^{
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:settingURL]) {
            [[UIApplication sharedApplication] openURL:settingURL];
        } else {
            [AppContext showProgressFailHUDWithMessage:@"跳转失败，请手动进入系统设置页面。"];
        }
    } cancelBlock:^{
        [LKUserDefaults setBool:NO forKey:LKUserDefaultsShouldCheckNoticationPermission];
        [AppContext showMessage:@"那好吧..."];
    }];
    
    contentView.titleLabel.text = title;
    contentView.contentLabel.text = content;
    LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
    [alert show];
}


@end
