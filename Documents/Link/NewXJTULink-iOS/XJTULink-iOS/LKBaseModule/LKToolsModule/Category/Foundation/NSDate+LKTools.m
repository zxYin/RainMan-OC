//
//  NSDate+LKTools.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/18.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSDate+LKTools.h"
#import "DateTools.h"

@implementation NSDate (LKTools)
+ (NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    return [dateComponent month];
}

+ (NSInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    long weekday = [dateComponent weekday];
    if (weekday == 1) {
        weekday = 6;
    } else {
        weekday = weekday - 2;
    }
    return weekday;
}

- (NSInteger)weekdayAbsolute {
    return ([self weekday] + 5) % 7;
}

+ (NSArray *)datesOfWeekForDate:(NSDate *)date {
    NSInteger weekday = [date weekdayAbsolute];
    NSDate *startDate = [date dateBySubtractingDays:weekday];
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<7; i++) {
        [dates addObject:[startDate dateByAddingDays:i]];
    }
    return dates;
}

+ (NSArray *)daysOfCurrentWeek {
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:7];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *date = [NSDate date];
    
    NSInteger weekday = [self weekday];
    
    [formatter setDateFormat:@"dd"];
    [days addObject:[formatter stringFromDate:date]];
    
    for (NSInteger i=0; i<weekday; i++) {
        date = [date dateByAddingTimeInterval:-24*60*60];
        [days insertObject:[formatter stringFromDate:date] atIndex:0];
    }
    
    date = [NSDate date];
    for (NSInteger i=weekday+1; i<7; i++) {
        date = [date dateByAddingTimeInterval:24*60*60];
        [days addObject:[formatter stringFromDate:date]];
    }
    
    return [days copy];
}

- (NSString *)lk_timeString {
    NSString *format = @"";
    NSMutableString *time = [[NSMutableString alloc] init];
    if([self isToday]) {
        [time appendString:@"今天 "];
        format = @"HH:mm";
    } else if([self isYesterday]) {
        [time appendFormat:@"昨天 "];
        format = @"HH:mm";
    } else {
        if ([[NSDate date] year] == [self year]) {
            format = @"MM-dd HH:mm";
        } else {
            format = @"yyyy-MM-dd HH:mm";
        }
    }
    [time appendFormat:@"%@", [self formattedDateWithFormat:format]];
    return [time copy];
}
@end
