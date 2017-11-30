//
//  ConfessionViewModel.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKPostModel.h"
#import "LKNetworking.h"

typedef NS_ENUM(NSInteger, LKRefreshType) {
    LKRefreshTypeDefault = 0,
    LKRefreshTypeIncrement,
    LKRefreshTypeDecrement,
};

typedef struct LKRefreshMode {
    LKRefreshType type;
    NSInteger index;//需要刷新的行数，仅在mode非0时有用
}RefreshMode;

RefreshMode LKRefreshModeMake(LKRefreshType type,NSInteger index);


@interface LKPostViewModel : NSObject<YLNetworkingRACProtocol>

@property (nonatomic, copy) NSString *postId;

/// 表白内容
@property (nonatomic, copy) NSString *content;

/// 时间
@property (nonatomic, copy) NSString *time;

/// 是否赞过
@property (nonatomic, assign, getter=isLiked) BOOL liked;

/// 赞数
@property (nonatomic, copy) NSString *likeCount;

/// 阅读量
@property (nonatomic, copy) NSString *readCount;

/// 评论数
@property (nonatomic, copy) NSString *commentCount;

/// 该表白与当前用户的关系
@property (nonatomic, assign) LKPostReleation relation;

/// 是否被接受
@property (nonatomic, assign, getter=isAccepted) BOOL accepted;

/// 是否为热门表白
@property (nonatomic, assign, getter=isHot) BOOL hot;

/// 已经赞的用户的头像
@property (nonatomic, copy) NSArray<NSURL *> *likeUserAvatars;

/// 表白的作者 （表白墙则没有此信息，其他墙会有）
@property (nonatomic, strong) LKUserModel *user;

@property (nonatomic, assign, getter=isNeedRefresh) BOOL needRefresh;

@property (nonatomic, strong) LKTextModel *tag;

/// 定向 ->
@property (nonatomic, copy) NSString *referStudent;


@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *bottomColor;

@property (nonatomic, assign) BOOL isDeleted;

- (instancetype)initWithModel:(LKPostModel *)model;
- (instancetype)initWithPostId:(NSString *)postId;

- (void)toggleLike;

- (void)acceptConfession;

- (BOOL)isEmpty;

+ (LKTextModel *)acceptTextModel;

- (void)postComment;
- (void)deleteComment;

@end
