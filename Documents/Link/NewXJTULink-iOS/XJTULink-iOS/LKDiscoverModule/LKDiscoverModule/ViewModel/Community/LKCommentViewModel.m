//
//  ConfessionCommentViewModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentViewModel.h"
#import "NSDate+LKTools.h"
#import <BlocksKit.h>
#import "Foundation+LKTools.h"
#import "Chameleon.h"
#import "LKLikeManager.h"
#import "User.h"
#import "AppContext.h"
@interface LKCommentViewModel()
@property (nonatomic, strong) LKCommentModel *model;
@end

@implementation LKCommentViewModel
- (instancetype)initWithModel:(LKCommentModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self setupRACWithModel:model];
    }
    return self;
}
- (void)setupRACWithModel:(LKCommentModel *)model {
    RAC(self, commentId) = RACObserve(model, commentId);
    RAC(self, time) = [RACObserve(model, timestamp) map:^id(NSNumber *timestamp) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
        return [date lk_timeString];
    }];
    RAC(self, content) = RACObserve(model, content);
    
    RAC(self, liked) = RACObserve(model, liked);
    RAC(self, likeCount) = [RACObserve(model, likeCount) map:^id(NSNumber *likeCount) {
        if ([likeCount integerValue] > 999) {
            return @"999+";
        }
        return [likeCount stringValue];
    }];
    
    RAC(self, remark) = RACObserve(model, remark);
    RAC(self, type) = RACObserve(model, type);

    RAC(self, user) = RACObserve(model, user);
    RAC(self, referUser) = RACObserve(model, referUser);
}

- (void)toggleLike {
    if (self.relation == ConfessionCommentRelationAuthor) {
        [AppContext showMessage:@"不能给自己点赞哦~"];
        return;
    }
    
    [[LKLikeManager sharedInstance] likeItemId:self.commentId
                                          type:kLKLikeItemTypeConfessionComment
                                      isCancel:self.model.liked];
    if (self.model.liked) {
        self.model.likeCount--;
        self.model.liked = NO;
    } else {
        self.model.likeCount ++;
        self.model.liked = YES;
    }
}



@end
