//
//  SearchViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchAPIManager.h"
#import "SearchResultModel.h"
#import "ClubViewModel.h"
#import <BlocksKit/BlocksKit.h>

@interface SearchViewModel()<YLAPIManagerDataSource>

@property (nonatomic, strong) SearchAPIManager *searchAPIManager;

@end
@implementation SearchViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
//        if ([x boolValue]) {
//            self.clubViewModels = nil;
//        }
        SearchResultModel *searchResultModel = [self.searchAPIManager fetchDataFromModel:SearchResultModel.class];
        
        SpecialColumnModel *specialColumnModel = [[SpecialColumnModel alloc] init];
        specialColumnModel.title = @"搜索结果";
        specialColumnModel.items = searchResultModel.articleModels;
        self.specialColumnModel = specialColumnModel;
        
        self.clubViewModels = [searchResultModel.clubModels bk_map:^id(ClubModel * obj) {
            return [[ClubViewModel alloc] initWithClubModel:obj];
        }];
    }];
}
#pragma mark - YLAPIManagerDataSource
- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.searchAPIManager) {
        params = @{
                   kSearchAPIManagerParamsKeyKeywords:self.keywords?:@""
                   };
    }
    return params;
}

#pragma mark - getter
- (NSArray<ClubViewModel *> *)clubViewModels {
    if (_clubViewModels == nil) {
        _clubViewModels = [NSArray array];
    }
    return _clubViewModels;
}

- (SearchAPIManager *)searchAPIManager {
    if (_searchAPIManager == nil) {
        _searchAPIManager = [SearchAPIManager new];
        _searchAPIManager.dataSource = self;
    }
    return _searchAPIManager;
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.searchAPIManager;
}

@end
