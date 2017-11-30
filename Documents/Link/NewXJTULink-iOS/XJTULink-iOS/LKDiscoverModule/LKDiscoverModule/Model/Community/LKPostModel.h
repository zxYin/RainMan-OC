//
//  ConfessionModel.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKUserModel.h"
#import <Mantle/Mantle.h>
#import "LKTextModel.h"
/// 描述表白和当前用户的关系
typedef NS_ENUM(NSInteger, LKPostReleation){
    LKPostReleationDefault, // 默认
    LKPostReleationAuthor,  // 作者
    LKPostReleationTarget,  // 被表白的人
};


@interface LKPostModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *postId;

/// 表白内容
@property (nonatomic, copy) NSString *content;

/// 时间戳(1970年至今秒数)
@property (nonatomic, assign) NSInteger timestamp;

/// 是否赞过
@property (nonatomic, assign, getter=isLiked) BOOL liked;

/// 赞数
@property (nonatomic, assign) NSInteger likeCount;

/// 阅读量
@property (nonatomic, assign) NSInteger readCount;

/// 评论数
@property (nonatomic, assign) NSInteger commentCount;

/// 该表白与当前用户的关系
@property (nonatomic, assign) LKPostReleation relation;

/// 是否被接受
@property (nonatomic, assign, getter=isAccepted) BOOL accepted;

/// 是否为热门表白
@property (nonatomic, assign, getter=isHot) BOOL hot;

/// 已经赞的用户的头像
@property (nonatomic, copy) NSArray<NSString *> *likeUserAvatars;

@property (nonatomic, strong) LKTextModel *tag;
/// 表白的作者 （备用）
@property (nonatomic, strong) LKUserModel *user;

/// 定向 ->
@property (nonatomic, copy) NSString *referName;
@property (nonatomic, copy) NSString *referAcademy;
@property (nonatomic, copy) NSString *referClass;

/// Style
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, copy) NSString *bottomColor;

- (void)updateFromModel:(LKPostModel *)model;

@end
