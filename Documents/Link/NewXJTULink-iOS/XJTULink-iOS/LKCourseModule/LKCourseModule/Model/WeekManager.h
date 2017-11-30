//
//  WeekManager.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const LKNotificationWeekDidUpdate;
@interface WeekManager : NSObject
@property (nonatomic, assign) NSInteger week;

+ (WeekManager *)sharedInstance;
@end
