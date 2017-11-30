//
//  LKSettingModule.h
//  LKSettingModule
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKService.h"
@interface LKSettingModule : NSObject

@end


@interface LKSettingService : LKService
- (UIViewController *)LKSetting_settingViewController:(NSDictionary *)params;
- (UIViewController *)LKSetting_profileViewController:(NSDictionary *)params;
@end
