//
//  LKCourseModule.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKCourseModule.h"
#import "CourseSection.h"
#import "TranscriptsViewController.h"
#import "CourseManager.h"
#import "CourseModel+TimeHelper.h"
#import "NSDate+LKTools.h"
#import "Foundation+LKCourse.h"
#import "WeekManager.h"
#import "TeachingEvaluationViewController.h"
#import "ScheduleViewController.h"
#import "ScheduleSection.h"

@implementation LKCourseService
AUTH_REQUIRE(@"LKCourse_transcriptsViewController", @"LKCourse_teachingEvaluationViewController")
- (RACSignal *)LKCourse_countdownSecondSignal:(NSDictionary *)params {
    return
    [[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]
      startWith:[NSDate date]]
      map:^id(id value) {
          return @([LKCourseService countdown]);
      }];
}

- (YLTableViewSection *)LKCourse_courseAdSection:(NSDictionary *)params {
    return [[CourseSection alloc] init];
}

- (YLTableViewSection *)LKCourse_scheduleSection:(NSDictionary *)params {
    return [[ScheduleSection alloc] init];
}

- (UIViewController *)LKCourse_transcriptsViewController:(NSDictionary *)params {
    return  [[TranscriptsViewController alloc] init];
}

- (UIViewController *)LKCourse_teachingEvaluationViewController:(NSDictionary *)params {
    return [[TeachingEvaluationViewController alloc] init];
}

- (UIViewController *)LKCourse_scheduleViewController:(NSDictionary *)params {
    return [[ScheduleViewController alloc] init];
}

#pragma mark - Private API
+ (NSInteger)countdown {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
    });
    
    NSDate *zeroDate = [formatter dateFromString:@"00:00:00"];
    NSDate *nowDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    // 注意这里转换一下，即忽略掉日期的影响
    
    NSInteger intervalOfNow = [nowDate timeIntervalSinceDate:zeroDate];
    
    NSInteger result = 0;
    
    NSInteger baseInterval = intervalOfNow;
    for (NSInteger offset=0; offset<8; offset++) {
        // 注意此处应该计算8天，来避免下一次课还是今天的情况
        
        NSInteger day = ([NSDate weekday] + offset) % 7;
        NSArray *courses = [CourseManager sharedInstance].courseTable[day];
        
        NSMutableArray *filterCourses = [NSMutableArray array];
        [courses enumerateObjectsUsingBlock:^(CourseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.weekFormatter.indexSet containsIndex:[WeekManager sharedInstance].week]) {
                [filterCourses addObject:obj];
            }
        }];
        
        NSArray *intervalList = [filterCourses intervalListOfCourses];
        
        __block NSInteger nextNode = -1;
        
        
        [intervalList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (baseInterval < [obj integerValue]) {
                nextNode = idx;
                *stop = YES;
            }
        }];
        
        
        if (nextNode == -1) {
            // 说明已经上完了今天的课
            // 需要计算下一天的时间
            
            if (offset == 0) {
                NSDate *endDate = [formatter dateFromString:@"23:59:59"];
                result += [endDate timeIntervalSinceDate:nowDate];
                
                // 之后的基准都是从0点开始计算时间
                baseInterval = 0;
                
                
            } else if(offset == 7) {
                // 如果已经扫了8天，但是又走到了这里
                // 说明已经没有课了
                // 这里使用NSInterMax来表示已经无课了
                result = NSIntegerMax;
                
            } else {
                result += 24 * 60 * 60;
            }
            
        } else {
            result += [intervalList[nextNode] integerValue] - baseInterval;
            if ([CourseModel isStartOfClassAtIndex:nextNode]) {
                // 如果是下一个是上课节点，则代表当前是下课时间，用负数表示
                result *= -1;
            }
            break;
        }
    }
    return result;
}

@end
