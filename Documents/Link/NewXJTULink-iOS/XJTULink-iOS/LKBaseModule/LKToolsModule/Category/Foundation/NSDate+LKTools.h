//
//  NSDate+LKTools.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/18.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTools.h"

@interface NSDate (LKTools)
+ (NSInteger)month;
+ (NSInteger)weekday;
+ (NSArray *)daysOfCurrentWeek;

+ (NSArray *)datesOfWeekForDate:(NSDate *)date;

// 从0开始
- (NSInteger)weekdayAbsolute;

// 将日期转换为日期
// 格式为:
// 今天 12:30
// 昨天 12:30
// 09-20 12:30
// 2016-09-20 12:30
- (NSString *)lk_timeString;
@end
