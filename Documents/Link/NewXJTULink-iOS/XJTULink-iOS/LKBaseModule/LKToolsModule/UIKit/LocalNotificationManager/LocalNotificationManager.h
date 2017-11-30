//
//  LocalNotificationManager.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/6/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
+ (void)registerLocalNotificationWithMessage:(NSString *)msg
                                      atDate:(NSDate *)date
                                         url:(NSString *)url
                                      forKey:(NSString *)key;

+ (void)cancelLocalNotificationWithKey:(NSString *)key;
@end
