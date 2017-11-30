//
//  AppMediator+LKSettingModule.m
//  LKMediator
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKSettingModule.h"
NSString * const kAppMediatorSettingModule= @"LKSettingModule";

NSString * const kAppMediatorSettingServiceSettingViewController = @"settingViewController";
NSString * const kAppMediatorSettingServiceProfileViewController = @"profileViewController";

@implementation AppMediator (LKSettingModule)
- (UIViewController *)LKSetting_settingViewController {
    return [[self performAction:kAppMediatorSettingServiceSettingViewController
                       onModule:kAppMediatorSettingModule
                         params:nil]
            safeType:[UIViewController class]];
}

- (void)LKSetting_profileViewController:(void(^)(UIViewController *vc))block {
    if (block) {
        [[self performAction:kAppMediatorSettingServiceProfileViewController
                    onModule:kAppMediatorSettingModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
}
@end
