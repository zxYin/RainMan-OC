//
//  ConfessionCommentAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentAPIManager.h"

NSString * const kCommentAPIManagerParamsKeyId = @"kCommentAPIManagerParamsKeyId";
NSString * const kCommentAPIManagerParamsKeyContent = @"kCommentAPIManagerParamsKeyContent";
NSString * const kCommentAPIManagerParamsKeyReferCommentId = @"kCommentAPIManagerParamsKeyReferCommentId";
NSString * const kCommentAPIManagerParamsKeyConfessionId = @"kCommentAPIManagerParamsKeyConfessionId";
NSString * const kCommentAPIManagerParamsKeyOnlyAuthor = @"kCommentAPIManagerParamsKeyOnlyAuthor";

///删除
@interface ConfessionCommentDeleteAPIManager : LKCommentAPIManager

@end
@implementation ConfessionCommentDeleteAPIManager
- (NSString *)path {
    return @"wall/deleteComment/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    
    resultParams[@"comment_id"] = params[kCommentAPIManagerParamsKeyId];
    return resultParams;
}


@end
///提交
@interface ConfessionCommentSubmitAPIManager : LKCommentAPIManager

@end
@implementation ConfessionCommentSubmitAPIManager
- (NSString *)path {
    return @"wall/postComment/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *comment = [[NSMutableDictionary alloc] init];
    comment[@"confession_id"] = params[kCommentAPIManagerParamsKeyConfessionId];
    comment[@"content"] = params[kCommentAPIManagerParamsKeyContent];
    comment[@"refer_comment_id"] = params[kCommentAPIManagerParamsKeyReferCommentId];
    comment[@"only_author"] = params[kCommentAPIManagerParamsKeyOnlyAuthor];
    if (comment.count > 0) {
        resultParams[@"comment"] = [comment copy];
    }
    return resultParams;
}

- (NSString *)keyOfResult {
    return @"comment";
}

@end

///父类
@implementation LKCommentAPIManager

- (NSString *)path {
    return @"";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

+ (instancetype)apiManagerByType:(CommentAPIManagerType)type {
    switch (type) {
        case CommentAPIManagerTypeDelete:
            return [[ConfessionCommentDeleteAPIManager alloc] init];
        case CommentAPIManagerTypeSubmit:
            return [[ConfessionCommentSubmitAPIManager alloc] init];
        default:
            break;
    }
    return nil;
}

@end
