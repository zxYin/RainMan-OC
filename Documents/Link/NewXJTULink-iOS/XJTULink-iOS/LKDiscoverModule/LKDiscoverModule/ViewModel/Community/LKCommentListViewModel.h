//
//  ConfessionCommentListViewModel.h
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/6.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "LKCommentViewModel.h"
#import "LKPostViewModel.h"
@interface LKCommentListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, assign) NSString *postId;
@property (nonatomic, copy) NSArray<LKCommentViewModel *> *commentViewModels;
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, assign) RefreshMode refreshMode;

- (void)insertModel:(LKCommentModel *)model;
- (void)removeModelAtIndex:(NSInteger)index;

- (instancetype)initWithConfessionId:(NSString *)confessionId;
@end
