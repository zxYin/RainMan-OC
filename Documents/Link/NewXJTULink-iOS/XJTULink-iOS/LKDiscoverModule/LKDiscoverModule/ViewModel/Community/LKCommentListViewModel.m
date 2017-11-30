//
//  ConfessionCommentListViewModel.m
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/6.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//


#import "LKCommentListViewModel.h"
#import <BlocksKit/BlocksKit.h>
#import "LikeAPIManager.h"
#import "LKCommentModel.h"
#import "LKCommentListAPIManager.h"

@interface LKCommentListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) LKCommentListAPIManager *commentListAPIManager;
@end

@implementation LKCommentListViewModel

- (instancetype)initWithConfessionId:(NSString *)confessionId {
    self = [super init];
    if (self) {
        self.postId = confessionId;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *commentViewModels = [x boolValue]?[NSMutableArray array]:[NSMutableArray arrayWithArray:self.commentViewModels];
        NSArray *confessionCommentModels = [self.commentListAPIManager fetchDataFromModel:LKCommentModel.class];
        [commentViewModels addObjectsFromArray:[confessionCommentModels bk_map:^id(LKCommentModel *obj) {
            return [[LKCommentViewModel alloc] initWithModel:obj];
        }]];
        self.commentViewModels = [commentViewModels copy];
    }];
    self.refreshMode = LKRefreshModeMake(LKRefreshTypeDefault, 0);
}

- (BOOL)hasNextPage {
    return self.commentListAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.commentListAPIManager;
}

- (void)insertModel:(LKCommentModel *)model {
    LKCommentViewModel *viewModel = [[LKCommentViewModel alloc] initWithModel:model];
    if (viewModel) {
        
        self.refreshMode = LKRefreshModeMake(LKRefreshTypeIncrement, 0);
        self.commentViewModels = [@[viewModel] arrayByAddingObjectsFromArray:self.commentViewModels];
    }
}

- (void)removeModelAtIndex:(NSInteger)index {
    NSMutableArray *tempArr = [self.commentViewModels mutableCopy];
    if (index<[tempArr count]) {
        [tempArr removeObjectAtIndex:index];
        self.refreshMode = LKRefreshModeMake(LKRefreshTypeDecrement, index);
        self.commentViewModels = [tempArr copy];
    }
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[kCommentListAPIManagerParamsKeyId] = self.postId;
    return resultParams;
}

#pragma mark - getter

- (LKCommentListAPIManager *)commentListAPIManager {
    if (_commentListAPIManager == nil) {
        _commentListAPIManager = [[LKCommentListAPIManager alloc] init];
        _commentListAPIManager.dataSource = self;
    }
    return _commentListAPIManager;
}


@end
