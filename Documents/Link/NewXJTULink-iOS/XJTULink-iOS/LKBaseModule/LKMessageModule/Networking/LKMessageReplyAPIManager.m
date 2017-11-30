//
//  LKMessageReplyAPIManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/4/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageReplyAPIManager.h"

NSString * const LKMessageReplyAPIManagerParamsKeyMessageId = @"LKMessageReplyAPIManagerParamsKeyMessageId";
NSString * const LKMessageReplyAPIManagerParamsKeyContent = @"LKMessageReplyAPIManagerParamsKeyContent";

@implementation LKMessageReplyAPIManager
- (NSString *)path {
    return @"message/replyMessage/";
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
    resultParams[@"message_id"] = params[LKMessageReplyAPIManagerParamsKeyMessageId];
    resultParams[@"content"] = params[LKMessageReplyAPIManagerParamsKeyContent];
    return resultParams;
}

#pragma mark -

@end
