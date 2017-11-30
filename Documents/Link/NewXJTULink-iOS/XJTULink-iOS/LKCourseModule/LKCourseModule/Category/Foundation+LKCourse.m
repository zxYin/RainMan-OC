//
//  Foundation+LKCourse.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "Foundation+LKCourse.h"
//#import "CourseTimeHelper.h"

#import "CourseModel+TimeHelper.h"

@implementation NSString (LKCourse)
- (NSInteger)weekdayValue {
    NSArray *weekdays = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    return [weekdays indexOfObject:self];
}

+ (NSString *)stringForWeekday:(NSInteger)weekday {
    if (weekday<0 && weekday>=7) {
        return nil;
    }
    NSArray *weekdays = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    return weekdays[weekday];
}
@end


@implementation NSArray(LKCourse)

- (NSUInteger)countWithTwoDimension {
    NSUInteger count = 0;
    for (NSArray *subarray in self) {
        count += [subarray count];
    }
    return count;
}

- (NSArray *)intervalListOfCourses {
    NSMutableArray *intervalList = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(CourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i=0; i<obj.timeRange.length; i++) {
            NSInteger courseIndex = obj.timeRange.location + i;
            
            NSInteger start = [CourseModel fetchSecondsFromIndex:2 * (courseIndex - 1)];
            NSInteger end = [CourseModel fetchSecondsFromIndex:2 * (courseIndex - 1) + 1];
            
            [intervalList addObject:@(start)];
            [intervalList addObject:@(end)];
        }
    }];
    return [intervalList copy];
}

@end


@implementation NSIndexSet (LKCourse)
- (NSArray *)lk_allIndexes {
    NSMutableArray *items = [NSMutableArray array];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:@(idx)];
    }];
    return [items copy];
}
@end
