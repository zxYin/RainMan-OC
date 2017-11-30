//
//  NewsAPIManager.m
//  XJTULink-Networking
//
//  Created by Yunpeng on 16/6/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NewsListAPIManager.h"
#import "NewsModel.h"
#import <Mantle/Mantle.h>

NSString * const kNewsAPIManagerParamsKeyTypes = @"kNewsAPIManagerParamsKeyTypes";
NSString * const kNewsAPIManagerParamsKeySources = @"kNewsAPIManagerParamsKeySources";

@interface NewsListAPIManager ()
@end

@implementation NewsListAPIManager
#pragma mark - life cycle

#pragma mark - YLAPIManager
- (NSString *)path {
    return @"campusInfo/getNewsList/";
}

- (NSString *)apiVersion {
    return @"2.0";
}

- (BOOL)isAuth {
    return NO;
}

- (BOOL)shouldCache {
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"news_types"] = params[kNewsAPIManagerParamsKeyTypes];
    resultParams[@"news_sources"] = params[kNewsAPIManagerParamsKeySources];
    resultParams[@"begin"] = @(self.currentPage * self.pageSize);
    resultParams[@"num"] = @(self.pageSize);
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"news_list";
}
@end
