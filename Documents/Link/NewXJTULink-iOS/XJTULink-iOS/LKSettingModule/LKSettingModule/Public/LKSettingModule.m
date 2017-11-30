//
//  LKSettingModule.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSettingModule.h"
#import "SettingViewController.h"
@implementation LKSettingModule

@end



@implementation LKSettingService
AUTH_REQUIRE(@"LKSetting_profileViewController")

- (UIViewController *)LKSetting_settingViewController:(NSDictionary *)params {
    return [[LKSettingService settingStoryboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
}

- (UIViewController *)LKSetting_profileViewController:(NSDictionary *)params {
    return [[LKSettingService settingStoryboard] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
}


+ (UIStoryboard *)settingStoryboard {
    static UIStoryboard *settingStoryboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingStoryboard = [UIStoryboard storyboardWithName:@"LKSetting" bundle:nil];
    });
    return settingStoryboard;
}
@end
