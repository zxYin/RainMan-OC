//
//  ConfessionListViewModel.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKNetworking.h"
#import "LKPostViewModel.h"


@interface LKPostListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, copy) NSArray<LKPostViewModel *> *confessionViewModels;
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, assign) RefreshMode refreshMode;
@property (nonatomic, assign) BOOL needEndRefresh;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray<NSString *> *messageUsers;

- (void)insertModel:(LKPostModel *)model;
- (void)removeModelForIndex:(NSInteger)index;
@end
