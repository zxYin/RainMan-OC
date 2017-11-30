//
//  ConfessionCommentAPIManager.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"

typedef NS_ENUM(NSInteger, CommentAPIManagerType) {
    CommentAPIManagerTypeSubmit = 0,
    CommentAPIManagerTypeDelete = 1,
};

extern NSString * const kCommentAPIManagerParamsKeyId;
extern NSString * const kCommentAPIManagerParamsKeyContent;
extern NSString * const kCommentAPIManagerParamsKeyReferCommentId;
extern NSString * const kCommentAPIManagerParamsKeyConfessionId;
extern NSString * const kCommentAPIManagerParamsKeyOnlyAuthor;


@interface LKCommentAPIManager : YLBaseAPIManager<YLAPIManager>

+ (instancetype)apiManagerByType:(CommentAPIManagerType)type;

@end
