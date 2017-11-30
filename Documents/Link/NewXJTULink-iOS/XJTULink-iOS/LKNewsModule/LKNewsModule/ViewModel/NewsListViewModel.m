//
//  NewsListViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/17.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NewsListViewModel.h"
#import "NewsListAPIManager.h"

@interface NewsListViewModel()<YLAPIManagerDataSource>

@property (nonatomic, copy) NSArray *types;
@property (nonatomic, copy) NSArray *sources;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NewsListAPIManager *newsAPIManager;

@end
@implementation NewsListViewModel
- (instancetype)init {
    return [self initWithTyes:nil sources:nil pageSize:20];
}

- (instancetype)initWithTyes:(NSArray *)types sources:(NSArray *)sources {
    return [self initWithTyes:types sources:sources pageSize:20];
}

- (instancetype)initWithTyes:(NSArray *)types sources:(NSArray *)sources pageSize:(NSInteger)pageSize {
    self = [super init];
    if (self) {
        self.types = types;
        self.sources = sources;
        self.pageSize = pageSize;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        NSLog(@"网络访问完毕");
        @strongify(self);
        if ([x boolValue]) {
            self.newsItemViewModels = nil;
        }
        
        NSMutableArray *newsViewModels = [NSMutableArray arrayWithArray:self.newsItemViewModels];
        NSArray *newsModels = [self.newsAPIManager fetchDataFromModel:NewsModel.class];
        RACSequence *newsViewModelSeq = [newsModels.rac_sequence map:^id(NewsModel *model) {
            return [[NewsItemViewModel alloc] initWithModel:model];
        }];
        [newsViewModels addObjectsFromArray:newsViewModelSeq.array];
        self.newsItemViewModels = newsViewModels;
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.newsAPIManager) {
        params = @{
                   kNewsAPIManagerParamsKeyTypes:@[],
                   kNewsAPIManagerParamsKeySources:@[],
                   };
    }
    return params;
}

#pragma mark - getter && setter
- (NewsListAPIManager *)newsAPIManager {
    if (_newsAPIManager == nil) {
        _newsAPIManager = [[NewsListAPIManager alloc] initWithPageSize:self.pageSize];
        _newsAPIManager.dataSource = self;
    }
    return _newsAPIManager;
}

- (BOOL)hasNextPage {
    return self.newsAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.newsAPIManager;
}
@end
