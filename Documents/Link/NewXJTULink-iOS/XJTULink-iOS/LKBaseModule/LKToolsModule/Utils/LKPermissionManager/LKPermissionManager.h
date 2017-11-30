//
//  LKPermissionManager.h
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKPermissionManager : NSObject
+ (instancetype)sharedInstance;
- (void)checkNotificationPermission;
- (void)checkNotificationPermissionWithMessage:(NSString *)message;
@end
