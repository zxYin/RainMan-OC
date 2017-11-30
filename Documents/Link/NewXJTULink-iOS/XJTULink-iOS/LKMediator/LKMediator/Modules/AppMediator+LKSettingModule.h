//
//  AppMediator+LKSettingModule.h
//  LKMediator
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"

@interface AppMediator (LKSettingModule)
- (UIViewController *)LKSetting_settingViewController;
- (void)LKSetting_profileViewController:(void(^)(UIViewController *vc))block;
@end
