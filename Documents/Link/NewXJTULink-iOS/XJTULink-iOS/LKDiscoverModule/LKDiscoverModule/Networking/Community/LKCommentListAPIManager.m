//
//  ConfessionCommentListAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentListAPIManager.h"
#import <Mantle/Mantle.h>
NSString * const kCommentListAPIManagerParamsKeyId = @"kCommentListAPIManagerParamsKeyId";
@implementation LKCommentListAPIManager
#pragma mark - life cycle

#pragma mark - YLAPIManager
- (NSString *)path {
    return @"wall/getConfessionCommentList/";
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
    resultParams[@"confession_id"] = params[kCommentListAPIManagerParamsKeyId];
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"comment_list";
}

- (NSString *)keyOfResultItemId {
    return @"id";
}
@end
