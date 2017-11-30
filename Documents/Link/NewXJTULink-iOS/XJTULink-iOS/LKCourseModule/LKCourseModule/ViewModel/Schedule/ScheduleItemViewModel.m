//
//  ScheduleItemViewModel.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleItemViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LKNetworking.h"
#import "ScheduleAPIManager.h"
#import "ScheduleManager.h"
#import "Foundation+LKTools.h"
#import "DateTools.h"

@interface ScheduleItemViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) ScheduleModel *model;
@property (nonatomic, strong) ScheduleAPIManager *scheduleAPIManager;
@end

@implementation ScheduleItemViewModel
- (instancetype)initWithModel:(ScheduleModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    RAC(self, eventId) = RACObserve(self.model, eventId);
    RAC(self, name) = RACObserve(self.model, name);
    RAC(self, time) = RACObserve(self.model, time);
    RAC(self, locale) = [RACObserve(self.model, locale) map:^id(NSString *locale) {
        if ([NSString isBlank:locale]) {
            return @"(未设置)";
        }
        return locale;
    }];
    
    RAC(self, leftDay) =
    [RACObserve(self.model, time) map:^id(NSString *value) {
        @strongify(self);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:self.model.timestamp]];
        components.day += 1;
        NSDate *startDate = [calendar dateFromComponents:components];
        NSInteger day = [startDate daysLaterThan:[NSDate date]];
        return @(day);
    }];
    RAC(self, isEnd) =
    [RACObserve(self.model, time) map:^id(NSString *value) {
        @strongify(self);
        return @(self.model.timestamp <= [[NSDate date] timeIntervalSince1970]);
    }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.scheduleAPIManager;
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kScheduleAPIManagerParamsKeyId] = [NSNumber numberWithInteger:self.eventId];
    return params;
}

- (void)deleteLocalArchive {
    [[ScheduleManager sharedInstance] deleteScheduleModelWithEventId:self.eventId];
}

#pragma mark - getter
- (ScheduleAPIManager *)scheduleAPIManager {
    if (_scheduleAPIManager == nil) {
        _scheduleAPIManager = [ScheduleAPIManager apiManagerByType:ScheduleAPIManagerTypeDelete];
        _scheduleAPIManager.dataSource = self;
    }
    return _scheduleAPIManager;
}
@end
