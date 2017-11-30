//
//  ClubListViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubListViewModel.h"
#import "ClubListAPIManager.h"
#import "ClubModel.h"
#import <BlocksKit/BlocksKit.h>
#import "YLGridTableViewCell.h"

@interface ClubListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSArray<NSDictionary *> *clubTypes;
@property (nonatomic, strong) ClubListAPIManager *clubListAPIManager;
@end
@implementation ClubListViewModel
- (instancetype)initWithInitialTypeId:(NSString *)typeId {
    self = [super init];
    if (self) {
        self.currentTypeId = typeId;
        [self setupData];
        [self setupRAC];
    }
    return self;
}

- (void)setupData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ClubTypes" ofType:@"plist"];
    NSArray *clubTypes = [NSArray arrayWithContentsOfFile:path];
    
    self.clubTypes =
    [clubTypes bk_map:^id(NSDictionary *type) {
         return @{
                  kClubTypeKeyImage:[UIImage imageNamed:type[@"image"]],
                  kClubTypeKeyTitle:type[@"title"],
                  kClubTypeKeyId:type[@"id"],
                  };
     }];
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSArray *clubViewModels = [x boolValue]?[NSArray array]:self.clubViewModels;
        NSArray *clubModels = [self.clubListAPIManager fetchDataFromModel:ClubModel.class];
        NSArray *newClubViewModels = [clubModels bk_map:^id(ClubModel * obj) {
            return [[ClubViewModel alloc] initWithClubModel:obj];
        }];
        self.clubViewModels = [clubViewModels arrayByAddingObjectsFromArray: newClubViewModels];
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.clubListAPIManager) {
        params = @{
                   kClubListAPIManagerParamsKeyClubTypeId:self.currentTypeId
                   };
    }
    return params;
}

- (NSString *)currentTypeId {
    return _currentTypeId?:@"0";
}

- (NSArray<ClubViewModel *> *)clubViewModels {
    if (_clubViewModels == nil) {
        _clubViewModels = [NSArray array];
    }
    return _clubViewModels;
}

- (ClubListAPIManager *)clubListAPIManager {
    if (_clubListAPIManager == nil) {
        _clubListAPIManager = [[ClubListAPIManager alloc] init];
        _clubListAPIManager.dataSource = self;
    }
    return _clubListAPIManager;
}

- (BOOL)hasNextPage {
    return self.clubListAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.clubListAPIManager;
}
@end
