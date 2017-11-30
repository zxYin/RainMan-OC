//
//  ActivityListViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityListViewModel.h"
#import "ActivityListAPIManager.h"
@interface ActivityListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSString *clubId;
@property (nonatomic, strong) ActivityListAPIManager *activityListAPIManager;
@end
@implementation ActivityListViewModel
- (instancetype)initWithClubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        self.clubId = clubId;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            self.activityModels = nil;
        }
        NSArray *activityModels = [self.activityListAPIManager fetchDataFromModel:ActivityModel.class];
        NSLog(@"activityModels:%@",activityModels);
        self.activityModels = [self.activityModels arrayByAddingObjectsFromArray:activityModels];
        NSLog(@"self.activityModels = %@",self.activityModels);
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.activityListAPIManager) {
        params = @{
                   kActivityListAPIManagerParamsKeyClubId:self.clubId
                   };
    }
    return params;
    
}

- (NSArray<ActivityModel *> *)activityModels {
    if (_activityModels == nil) {
        _activityModels = [NSArray array];
    }
    return _activityModels;
}

- (ActivityListAPIManager *)activityListAPIManager {
    if (_activityListAPIManager == nil) {
        _activityListAPIManager = [[ActivityListAPIManager alloc] initWithPageSize:999];
        _activityListAPIManager.dataSource = self;
    }
    return _activityListAPIManager;
}

- (BOOL)hasNextPage {
    return self.activityListAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.activityListAPIManager;
}
@end
