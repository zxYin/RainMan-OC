//
//  ScheduleEditViewModel.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleEditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ScheduleAPIManager.h"
#import "ScheduleManager.h"

NSString * const kNetworkingRACTypeScheduleAdd = @"kNetworkingRACTypeScheduleAdd";
NSString * const kNetworkingRACTypeScheduleDelete = @"kNetworkingRACTypeScheduleDelete";
NSString * const kNetworkingRACTypeScheduleUpdate = @"kNetworkingRACTypeScheduleUpdate";

@interface ScheduleEditViewModel()<YLAPIManagerDataSource, YLAPIManagerInterceptor>
@property (nonatomic, strong) YLNetworkingRACTable *networkingRACs;
@property (nonatomic, strong) ScheduleAPIManager *scheduleAddAPIManager;
@property (nonatomic, strong) ScheduleAPIManager *scheduleDeleteAPIManager;
@property (nonatomic, strong) ScheduleAPIManager *scheduleUpdateAPIManager;
@end

@implementation ScheduleEditViewModel
- (instancetype)initWithType:(ScheduleEditViewModelType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    RACSignal *nameValid = [RACObserve(self, scheduleModel.name) map:^id(id value) {
        NSLog(@"nameValid :%@", value);
        return @([value length] > 0);
    }];
    
    RACSignal *timeValid = [RACObserve(self, scheduleModel.time) map:^id(id value) {
        NSLog(@"timeValid :%@", value);
        return @([value length] > 0);
    }];

    RAC(self, isValid) =
    [RACSignal combineLatest:@[nameValid, timeValid]
                      reduce:^id(NSNumber *nameValid, NSNumber *timeValid){
                          return @([nameValid boolValue]
                          && [timeValid boolValue]);
                      }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([NSStringFromClass(manager.class) isEqualToString:@"ScheduleDeleteAPIManager"]) {
        params[kScheduleAPIManagerParamsKeyId] = [NSNumber numberWithInteger:self.scheduleModel.eventId];
    } else {
        if ([NSStringFromClass(manager.class) isEqualToString:@"ScheduleUpdateAPIManager"]) {
            params[kScheduleAPIManagerParamsKeyId] = [NSNumber numberWithInteger:self.scheduleModel.eventId];
        }
        params[kScheduleAPIManagerParamsKeyName] = self.scheduleModel.name;
        params[kScheduleAPIManagerParamsKeyTime] = self.scheduleModel.time;
        params[kScheduleAPIManagerParamsKeyLocale] = self.scheduleModel.locale;
    }
    return params;
}

- (YLNetworkingRACTable *)networkingRACs {
    if (_networkingRACs == nil) {
        _networkingRACs = [YLNetworkingRACTable strongToWeakObjectsMapTable];
        _networkingRACs[kNetworkingRACTypeScheduleAdd] = self.scheduleAddAPIManager;
        _networkingRACs[kNetworkingRACTypeScheduleDelete] = self.scheduleDeleteAPIManager;
        _networkingRACs[kNetworkingRACTypeScheduleUpdate] = self.scheduleUpdateAPIManager;
    }
    return _networkingRACs;
}

#pragma mark - YLAPIManagerInterceptor
- (void)apiManager:(YLBaseAPIManager *)manager afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    ScheduleModel *model;
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseModel.responseData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:&error];
    if (jsonDict[@"data"]) {
        model = [MTLJSONAdapter modelOfClass:ScheduleModel.class fromJSONDictionary:jsonDict[@"data"] error:NULL];
    }
    if ([NSStringFromClass(manager.class) isEqualToString:@"ScheduleAddAPIManager"]) {
        if (model) {
            [[ScheduleManager sharedInstance] addScheduleModel:model];
        }
    } else if ([NSStringFromClass(manager.class) isEqualToString:@"ScheduleUpdateAPIManager"]) {
        if (model) {
            [[ScheduleManager sharedInstance] updateScheduleModel:model];
        }
    } else if([NSStringFromClass(manager.class) isEqualToString:@"ScheduleDeleteAPIManager"]) {
        if (model) {
            [[ScheduleManager sharedInstance] deleteScheduleModelWithEventId:model.eventId];
        }
    }
}

#pragma mark - getter
- (ScheduleAPIManager *)scheduleAddAPIManager {
    if (_scheduleAddAPIManager == nil) {
        _scheduleAddAPIManager = [ScheduleAPIManager apiManagerByType:ScheduleAPIManagerTypeAdd];
        _scheduleAddAPIManager.dataSource = self;
        _scheduleAddAPIManager.interceptor = self;
    }
    return _scheduleAddAPIManager;
}

- (ScheduleAPIManager *)scheduleDeleteAPIManager {
    if (_scheduleDeleteAPIManager == nil) {
        _scheduleDeleteAPIManager = [ScheduleAPIManager apiManagerByType:ScheduleAPIManagerTypeDelete];
        _scheduleDeleteAPIManager.dataSource = self;
        _scheduleDeleteAPIManager.interceptor = self;
    }
    return _scheduleDeleteAPIManager;
}

- (ScheduleAPIManager *)scheduleUpdateAPIManager {
    if (_scheduleUpdateAPIManager == nil) {
        _scheduleUpdateAPIManager = [ScheduleAPIManager apiManagerByType:ScheduleAPIManagerTypeUpdate];
        _scheduleUpdateAPIManager.dataSource = self;
        _scheduleUpdateAPIManager.interceptor = self;
    }
    return _scheduleUpdateAPIManager;
}

- (ScheduleModel *)scheduleModel {
    if (_scheduleModel == nil) {
        _scheduleModel = [[ScheduleModel alloc] init];
    }
    return _scheduleModel;
}

@end
