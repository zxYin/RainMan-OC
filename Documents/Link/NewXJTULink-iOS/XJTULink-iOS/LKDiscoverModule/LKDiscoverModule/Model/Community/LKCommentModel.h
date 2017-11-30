//
//  ConfessionCommentModel.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "LKUserModel.h"

typedef NS_ENUM(NSInteger, CommentType){
    CommentTypeDefault, // 正常模式
    CommentTypeMosaic,  // 马赛克样式
};



@interface LKCommentModel : MTLModel<MTLJSONSerializing>

/// 评论ID
@property (nonatomic, copy) NSString *commentId;

/// 评论内容
@property (nonatomic, copy) NSString *content;

/// 时间戳
@property (nonatomic, assign) NSInteger timestamp;

/// 是否赞过
@property (nonatomic, assign, getter=isLiked) BOOL liked;

@property (nonatomic, assign) CommentType type;

@property (nonatomic, copy) NSString *remark;

/// 赞数
@property (nonatomic, assign) NSInteger likeCount;

/// 评论作者
@property (nonatomic, strong) LKUserModel *user;

/// 评论回复的用户
@property (nonatomic, strong) LKUserModel *referUser;

@end
