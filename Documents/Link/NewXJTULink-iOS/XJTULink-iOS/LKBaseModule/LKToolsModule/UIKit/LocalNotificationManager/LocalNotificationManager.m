//
//  LocalNotificationManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/6/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LocalNotificationManager.h"
#import <UIKit/UIKit.h>
#import "Constants.h"
@implementation LocalNotificationManager
+ (void)registerLocalNotificationWithMessage:(NSString *)msg
                                      atDate:(NSDate *)date
                                        url:(NSString *)url
                                      forKey:(NSString *)key {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    notification.fireDate = date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    
    // 通知内容
    notification.alertBody = msg;
    notification.alertAction = msg;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    userDict[kLocalNotificationURL] = url;
    userDict[kLocalNotificationKey] = key;

    notification.userInfo = [userDict copy];
    
    // ios8后，需要添加这个注册，才能得到授权
    UIUserNotificationType notitype =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notitype
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *info = userInfo[kLocalNotificationKey];
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;  
            }  
        }  
    }  
}
@end
