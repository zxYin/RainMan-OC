//
//  NewsListViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/17.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "NewsItemViewModel.h"

@interface NewsListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, copy) NSArray<NewsItemViewModel *> *newsItemViewModels;

- (instancetype)initWithTyes:(NSArray *)types sources:(NSArray *)sources;
- (instancetype)initWithTyes:(NSArray *)types sources:(NSArray *)sources pageSize:(NSInteger)pageSize;
@end
