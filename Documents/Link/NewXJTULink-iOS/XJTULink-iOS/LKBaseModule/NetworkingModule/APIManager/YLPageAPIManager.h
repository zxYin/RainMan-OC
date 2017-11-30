//
//  YLPageAPIManager.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"

extern const NSInteger kPageSizeNotFound;
extern const NSInteger kPageIsLoading;

@protocol YLPageAPIManager<YLAPIManager>

@required
- (NSString *)keyOfResult;

@optional
// 当使用sinceId时，必须先实现这个方法
- (NSString *)keyOfResultItemId;
@end

// 子类化时必须实现YLPageAPIManager协议
@interface YLPageAPIManager : YLBaseAPIManager

// 上次请求的最后一条记录的id（如果currentPage==0，则为nil）
@property (nonatomic, copy, readonly) NSString *sinceId;

// 请求页面大小
@property (nonatomic, assign, readonly) NSInteger pageSize;

// 当前页码
@property (nonatomic, assign, readonly) NSInteger currentPage;

// 当前页面大小，从未加载过时，应返回kPageSizeNotFound
@property (nonatomic, assign, readonly) NSInteger currentPageSize;

// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasNextPage;

// 重置currentPage
- (void)reset;
- (void)resetToPage:(NSInteger)page;

- (NSInteger)loadNextPage; // 如果正在加载则返回 kPageIsLoading，否则则返回requestId
- (NSInteger)loadNextPageWithoutCache;


- (instancetype)initWithPageSize:(NSInteger)pageSize;
- (instancetype)initWithPageSize:(NSInteger)pageSize startPage:(NSInteger)page NS_DESIGNATED_INITIALIZER;
@end
