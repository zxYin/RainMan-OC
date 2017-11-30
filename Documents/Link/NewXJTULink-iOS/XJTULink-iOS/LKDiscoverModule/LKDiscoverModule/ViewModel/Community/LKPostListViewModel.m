//
//  ConfessionListViewModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostListViewModel.h"
#import <BlocksKit/BlocksKit.h>
#import "LKPostListAPIManager.h"
#import "LikeAPIManager.h"
#import "CommunityContext.h"
#import "NSDictionary+LKValueGetter.h"
#import "Foundation+LKTools.h"
#import "Chameleon.h"
@interface LKPostListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray *> *confessionViewModelDict;

@property (nonatomic, strong) LKPostListAPIManager *postListAPIManager;
@end

@implementation LKPostListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.needEndRefresh = NO;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *confessionViewModels = [x boolValue]?[NSMutableArray array]:[NSMutableArray arrayWithArray:self.confessionViewModels];
        NSArray *confessionModels = [self.postListAPIManager fetchDataFromModel:LKPostModel.class];
        [confessionViewModels addObjectsFromArray:[confessionModels bk_map:^id(LKPostModel *obj) {
            return [[LKPostViewModel alloc] initWithModel:obj];
        }]];
    
        NSDictionary *messageDict = [[[self.postListAPIManager fetchData] dictionaryForKey:@"data"] dictionaryForKey:@"message"];
        NSString *count = [messageDict stringForKey:@"count"];
        if ([NSString notBlank:count]
            && [count integerValue] > 0) {
            if ([count integerValue] > 99) {
                count = @"99+";
            }
            self.message = [NSString stringWithFormat:@"%@条新消息",count];
            self.messageUsers = [messageDict arrayForKey:@"users"];
        } else {
            self.message = nil;
            self.messageUsers = nil;
        }
        
        self.refreshMode = LKRefreshModeMake(LKRefreshTypeDefault, 0);
        CommunityOption *type = [CommunityContext currentContext].currentOption;
        self.confessionViewModelDict[type.optionId] = [confessionViewModels copy];
        self.confessionViewModels = [confessionViewModels copy];
        self.needEndRefresh = YES;
    }];
    
    [RACObserve([CommunityContext currentContext], currentOption) subscribeNext:^(CommunityOption *type) {
        self.confessionViewModels = self.confessionViewModelDict[type.optionId];
    }];
    
}

- (void)insertModel:(LKPostModel *)model {
    LKPostViewModel *viewModel = [[LKPostViewModel alloc] initWithModel:model];
    if (viewModel) {
        LKPostViewModel *firstViewModel = [self.confessionViewModels firstObject];
        if(firstViewModel != nil
           && firstViewModel.backgroundColor != nil
           && ![[firstViewModel.backgroundColor hexValue] isEqualToString:@"#FFFFFF"]) {
            // 如果当前第一条为彩色背景的话，则将本条置为白色
            model.textColor = nil;
            model.bottomColor = nil;
            model.backgroundColor = nil;
        }
        self.refreshMode = LKRefreshModeMake(LKRefreshTypeIncrement, 0);
        self.confessionViewModels = [@[viewModel] arrayByAddingObjectsFromArray:self.confessionViewModels];
    }
}

- (void)removeModelForIndex:(NSInteger)index {
    NSMutableArray *tempArr = [self.confessionViewModels mutableCopy];
    if (index<[tempArr count]) {
        [tempArr removeObjectAtIndex:index];
        self.refreshMode = LKRefreshModeMake(LKRefreshTypeDecrement, index);
        self.confessionViewModels = [tempArr copy];
    }
}

- (BOOL)hasNextPage {
    return self.postListAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.postListAPIManager;
}

- (BOOL)isLoading {
    return self.postListAPIManager.isLoading;
}

#pragma mark - 
- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    CommunityContext *context = [CommunityContext currentContext];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kPostListAPIManagerKeyCommunityId] = context.communityId;
    params[kPostListAPIManagerKeyOptionId] = context.currentOption.optionId;
    return [params copy];
}

#pragma mark - getter

- (LKPostListAPIManager *)postListAPIManager {
    if (_postListAPIManager == nil) {
        _postListAPIManager = [[LKPostListAPIManager alloc] initWithPageSize:20];
        _postListAPIManager.dataSource = self;
    }
    return _postListAPIManager;
}

- (NSMutableDictionary<NSString *,NSArray *> *)confessionViewModelDict {
    if (_confessionViewModelDict == nil) {
        _confessionViewModelDict = [[NSMutableDictionary alloc] init];
    }
    return _confessionViewModelDict;
}

@end
