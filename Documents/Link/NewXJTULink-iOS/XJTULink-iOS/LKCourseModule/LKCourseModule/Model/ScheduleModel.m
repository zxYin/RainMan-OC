//
//  ScheduleModel.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleModel.h"

@implementation ScheduleModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"eventId":@"event_id",
             @"name":@"event_name",
             @"time":@"event_time",
             @"locale":@"event_locale",
             };
}

- (NSTimeInterval)timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    if (_time) {
        NSDate *dateSchedule = [formatter dateFromString:_time];
        if (dateSchedule) {
            _timestamp = [dateSchedule timeIntervalSince1970];
            return _timestamp;
        }
    }
    _timestamp = [[NSDate distantFuture] timeIntervalSince1970];
    return _timestamp;
    
}

-(id)copyWithZone:(NSZone *)zone {
    ScheduleModel *newModel = [[ScheduleModel allocWithZone:zone] init];
    newModel.name = self.name;
    newModel.time = self.time;
    newModel.locale = self.locale;
    
    return newModel;
}
@end
