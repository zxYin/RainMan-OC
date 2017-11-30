//
//  CourseModel+TimeHelper.m
//  LKCourseModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "CourseModel+TimeHelper.h"
#import "NSDate+LKTools.h"

@implementation CourseModel (TimeHelper)
- (NSInteger)startTimeIndex {
    return 2 * (self.timeRange.location - 1);
}

- (NSInteger)endTimeIndex {
    return self.startTimeIndex + self.timeRange.length;
}



+ (NSString *)fetchTimeFromIndex:(NSInteger)index {
//    NSLog(@"%s index: %td",__func__,index);
    
    static NSArray *schedule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger month = [NSDate month];
        NSString *classTimeType = (month < 10 && month >= 5)?@"summer":@"winter";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ClassTime" ofType:@"plist"];
        schedule = [NSDictionary dictionaryWithContentsOfFile:path][classTimeType];
    });
    
    
    if(index < 0 || index >= [schedule count]) {
        return nil;
    } else {
        return schedule[index];
    }
}

+ (NSInteger)fetchSecondsFromIndex:(NSInteger)index {
    NSString *time = [self fetchTimeFromIndex:index];
    NSDate *zeroDate = [NSDate dateWithString:@"00:00:00" formatString:@"HH:mm:ss"];
    return [[NSDate dateWithString:time formatString:@"HH:mm:ss"] timeIntervalSinceDate:zeroDate];
}

+ (BOOL)isStartOfClassAtIndex:(NSInteger)index {
    // 偶数是上课时间点
    // 奇数是下课时间点
    return ((index % 2) == 0) ? YES:NO;
}


@end
