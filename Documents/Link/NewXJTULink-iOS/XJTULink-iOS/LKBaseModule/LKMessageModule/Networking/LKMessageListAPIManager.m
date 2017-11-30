//
//  LKMessageListAPIManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageListAPIManager.h"
NSString * const LKMessageListAPIManagerParamsKeyCommunityId = @"LKMessageListAPIManagerParamsKeyCommunityId";
NSString * const LKMessageListAPIManagerParamsKeyOptionId = @"LKMessageListAPIManagerParamsKeyOptionId";
@implementation LKMessageListAPIManager
#pragma mark - life cycle

#pragma mark - YLAPIManager
- (NSString *)path {
    return @"message/getMessageList/";
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
    resultParams[@"community_id"] = params[LKMessageListAPIManagerParamsKeyCommunityId];
    resultParams[@"option_id"] = params[LKMessageListAPIManagerParamsKeyOptionId];
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"message_list";
}

- (NSString *)keyOfResultItemId {
    return @"id";
}
@end
