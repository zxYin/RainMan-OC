//
//  CourseViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseViewModel.h"
#import "Foundation+LKCourse.h"
#import "Foundation+LKTools.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CourseModel+TimeHelper.h"
#import "ScheduleManager.h"

@interface CourseViewModel()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *rawTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSIndexSet *weekSet;
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *teacher;

@end

@implementation CourseViewModel
@dynamic title,dayIndex,startIndex,length;


- (instancetype)initWithModel:(CourseModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        
        RAC(self, name) = RACObserve(model, name);
        RAC(self, locale) = RACObserve(model, locale);
        @weakify(self);
        
        [RACObserve(model, timeRange) subscribeNext:^(id x) {
            @strongify(self);
            self.time = LKTimeFromRange(model.timeRange);
            NSString *startTime = [[CourseModel fetchTimeFromIndex:model.startTimeIndex] substringToIndex:5];
            NSString *endTime = [[CourseModel fetchTimeFromIndex:model.endTimeIndex] substringToIndex:5];
            self.rawTime = [NSString stringWithFormat:@"%@-%@",startTime, endTime];
        }];
        
        RAC(self, week) = [RACObserve(model, week) map:^id(id value) {
            return model.weekFormatter.groupedString;
        }];
        
        RAC(self, weekday) = [RACObserve(model, weekday) map:^id(id value) {
            return [NSString stringForWeekday:model.weekday];
        }];
    }
    return self;
}


- (NSString *)title {
    if ([NSString isBlank:self.locale]) {
        return self.name;
    } else {
        return [NSString stringWithFormat:@"%@\n@%@",self.name,self.locale];
    }
}

- (NSInteger)dayIndex {
    return self.model.weekday;
}

- (NSInteger)startIndex {
    return self.model.timeRange.location - 1;
}

- (NSInteger)length {

    return self.model.timeRange.length;
}
@end


@implementation CourseViewModel(Schedule)
- (ScheduleItemViewModel *)scheduleItemViewModel {
    ScheduleModel *model =
    [[ScheduleManager sharedInstance] fetchScheduleModelForKey:self.name];
    if (model == nil) {
        return nil;
    }
    return [[ScheduleItemViewModel alloc] initWithModel:model];
}
@end
