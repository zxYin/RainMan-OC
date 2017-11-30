//
//  YLPageAPIManager.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLPageAPIManager.h"
#import <Mantle/Mantle.h>
#import "NSDictionary+LKValueGetter.h"
const NSInteger kPageSizeNotFound = -1;
const NSInteger kPageIsLoading = -1;
const NSInteger kYLPageAPIManagerDefaultPageSize = 10;

@interface YLPageAPIManager()
@property (nonatomic, assign, readwrite) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, weak) id<YLPageAPIManager> child;

@end
@implementation YLPageAPIManager
#pragma mark - init
- (instancetype)init {
    return [self initWithPageSize:kYLPageAPIManagerDefaultPageSize startPage:0];
}

- (instancetype)initWithPageSize:(NSInteger)pageSize {
    return [self initWithPageSize:pageSize startPage:0];
}

- (instancetype)initWithStartPage:(NSInteger)page {
    return [self initWithPageSize:kYLPageAPIManagerDefaultPageSize startPage:page];
}

- (instancetype)initWithPageSize:(NSInteger)pageSize startPage:(NSInteger)page {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YLPageAPIManager)]) {
            self.child = (id <YLPageAPIManager>)self;
        } else {
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ init failed",[self class]]
                                           reason:@"Subclass of YLPageAPIManager should implement <YLPageAPIManager>"
                                         userInfo:nil];
        }

#ifdef DEBUG
        if (![self.child respondsToSelector:@selector(keyOfResult)]) {
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ ERROR",[self class]]
                                           reason:@"Must implemente `keyOfResult`."
                                         userInfo:nil];
        }
#endif
        
        self.hasNextPage = YES;
        self.currentPage = page;
        self.pageSize = pageSize;
    }
    return self;
}

#pragma mark - logic

- (void)reset {
    [self resetToPage:0];
    
}

- (void)resetToPage:(NSInteger)page {
    self.currentPage = page;
    self.hasNextPage = YES;
}

- (NSInteger)loadNextPage {
    if (self.isLoading) {
        return kPageIsLoading;
    }
    return [super loadData];
}

- (NSInteger)loadNextPageWithoutCache {
    if (self.isLoading) {
        return kPageIsLoading;
    }
    return [super loadDataWithoutCache];
}


#pragma mark - override
- (NSInteger)loadData {
   return [self loadNextPage];
//    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ load error",[self class]]
//                                   reason:@"Don't call this Method. Call loadNextPage instead."
//                                 userInfo:nil];
}

- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    self.currentPage += 1;
    if (
//        self.currentPageSize != kPageSizeNotFound
//        &&
        self.currentPageSize < self.pageSize) {
        self.hasNextPage = NO;
    }
    return [super beforePerformSuccessWithResponseModel:responseModel];
}

- (BOOL)beforePerformFailWithResponseError:(YLResponseError *)error {
    if (self.currentPage > 0) {
        self.currentPage --;
    }
    return [super beforePerformFailWithResponseError:error];
}

- (id)fetchDataFromModel:(Class)clazz {
    NSError *error = nil;
    id result = [MTLJSONAdapter modelsOfClass:clazz
                                fromJSONArray:[self resultDictArray]
                                        error:&error];
    if(error) {
        NSLog(@"%@",error);
    }
    NSLog(@"%@", [self resultDictArray]);
    return result;
}

#pragma mark - getter && setter
- (void)setPageSize:(NSInteger)pageSize {
    if (pageSize<=0) {
        NSLog(@"pageSize can't < 0");
        _pageSize = kYLPageAPIManagerDefaultPageSize;
    } else {
        _pageSize = pageSize;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = MAX(0, currentPage);
}

- (NSInteger)currentPageSize {
    return self.resultDictArray.count > 0 ? self.resultDictArray.count : kPageSizeNotFound;
}

- (NSString *)sinceId {
    if (self.currentPage <= 0) {
        return nil;
    }
    
#ifdef DEBUG
    if (![self.child respondsToSelector:@selector(keyOfResultItemId)]) {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ ERROR",[self class]]
                                       reason:@"Must implemente `keyOfResultItemId` before calling `sinceId`."
                                     userInfo:nil];
    }
#endif
    id obj = [self.resultDictArray lastObject];
    if ([obj isKindOfClass:[NSDictionary class]]
        && [self.child respondsToSelector:@selector(keyOfResultItemId)]) {
        return obj[self.child.keyOfResultItemId];
    }
    return nil;
}


- (NSArray *)resultDictArray {
    if ([super fetchData]) {
        return [[[super fetchData] dictionaryForKey:@"data"] arrayForKey:self.child.keyOfResult];
    }
    return nil;
}

@end
