//
//  ConfessionCommentViewModel.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCommentModel.h"
#import "LKPostModel.h"

typedef NS_ENUM(NSInteger, ConfessionCommentRelation) {
    ConfessionCommentRelationDefault = 0,
    ConfessionCommentRelationAuthor = 1,
};

@interface LKCommentViewModel : NSObject

- (instancetype)initWithModel:(LKCommentModel *)model;
/// 评论ID
@property (nonatomic, copy) NSString *commentId;

/// 评论内容
@property (nonatomic, copy) NSString *content;


/// 时间
@property (nonatomic, copy) NSString *time;

/// 是否赞过
@property (nonatomic, assign, getter=isLiked) BOOL liked;

@property (nonatomic, assign) CommentType type;

@property (nonatomic, copy) NSString *remark;

/// 赞数
@property (nonatomic, copy) NSString *likeCount;

/// 评论作者
@property (nonatomic, strong) LKUserModel *user;

/// 评论回复的用户
@property (nonatomic, strong) LKUserModel *referUser;

@property (nonatomic, assign) ConfessionCommentRelation relation;

- (void)toggleLike;

@end
