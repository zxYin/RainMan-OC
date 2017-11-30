//
//  ScheduleListViewModel.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleListViewModel.h"
#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ScheduleAPIManager.h"
#import <BlocksKit/BlocksKit.h>
#import "ScheduleManager.h"

@interface ScheduleListViewModel()
@property (nonatomic, strong) ScheduleAPIManager *scheduleAPIManager;
@end

@implementation ScheduleListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    ScheduleManager *manager = [ScheduleManager sharedInstance];
    @weakify(self);
    [RACObserve(manager, scheduleModels) subscribeNext:^(id x) {
        @strongify(self);
        NSArray *scheduleModels = manager.scheduleModels;
        NSArray *newScheduleItemViewModels = [scheduleModels bk_map:^id(ScheduleModel * obj) {
            return [[ScheduleItemViewModel alloc] initWithModel:obj];
        }];
        self.scheduleItemViewModels = newScheduleItemViewModels;
    }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return [[ScheduleManager sharedInstance] networkingRAC];
}

@end
