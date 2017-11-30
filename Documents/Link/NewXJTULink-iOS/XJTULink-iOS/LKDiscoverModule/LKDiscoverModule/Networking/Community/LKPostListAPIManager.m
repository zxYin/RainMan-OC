//
//  ConfessionListAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostListAPIManager.h"
#import <Mantle/Mantle.h>
NSString * const kPostListAPIManagerKeyCommunityId = @"kPostListAPIManagerKeyCommunityId";
NSString * const kPostListAPIManagerKeyOptionId = @"kPostListAPIManagerKeyOptionId";
@implementation LKPostListAPIManager
#pragma mark - life cycle

#pragma mark - YLAPIManager
- (NSString *)path {
    return @"wall/getConfessionList/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"since_id"] = [self sinceId];
    resultParams[@"count"] = @(self.pageSize);
    resultParams[@"community_id"] = params[kPostListAPIManagerKeyCommunityId];
    resultParams[@"option_id"] = params[kPostListAPIManagerKeyOptionId];
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"confession_list";
}

- (NSString *)keyOfResultItemId {
    return @"id";
}
@end
