//
//  ConfessionViewModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostViewModel.h"
#import "NSDate+LKTools.h"
#import <BlocksKit.h>
#import "Foundation+LKTools.h"
#import "Chameleon.h"
#import "LKLikeManager.h"
#import "User.h"
#import "LKPostAPIManager.h"
#import "AppContext.h"
#import "AcademyManager.h"

RefreshMode LKRefreshModeMake(LKRefreshType type,NSInteger index) {
    RefreshMode mode = {type,index};
    return mode;
};

@interface LKPostViewModel()<YLAPIManagerDelegate,YLAPIManagerDataSource>
@property (nonatomic, strong) LKPostModel *model;
@property (nonatomic, strong) LKPostAPIManager *postAPIManager;
@end

@implementation LKPostViewModel
- (instancetype)initWithModel:(LKPostModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self setupRACWithModel:model];
    }
    return self;
}

- (instancetype)initWithPostId:(NSString *)postId {
    self = [super init];
    if (self) {
        LKPostModel *model = [[LKPostModel alloc] init];
        model.postId = postId;
        _model = model;
        [self setupRACWithModel:model];
        self.needRefresh = YES;
    }
    return self;
}

- (void)setupRACWithModel:(LKPostModel *)model {
    RAC(self, postId) = RACObserve(model, postId);
    RAC(self, time) = [RACObserve(model, timestamp) map:^id(NSNumber *timestamp) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
        return [date lk_timeString];
    }];
    RAC(self, content) = RACObserve(model, content);
    RAC(self, user) = RACObserve(model, user);
    RAC(self, liked) = RACObserve(model, liked);
    RAC(self, likeCount) = [RACObserve(model, likeCount) map:^id(NSNumber *likeCount) {
        if ([likeCount integerValue] > 999) {
            return @"999+";
        }
        return [likeCount stringValue];
    }];
    
    RAC(self, readCount) = [RACObserve(model, readCount) map:^id(NSNumber *readCount) {
        return [readCount stringValue];
    }];
    
    RAC(self, commentCount) = [RACObserve(model, commentCount) map:^id(NSNumber *commentCount) {
        if ([commentCount integerValue] > 999) {
            return @"评论 999+";
        }
        return [NSString stringWithFormat:@"评论 %@",[commentCount stringValue]];
    }];
    
    RAC(self, relation) = RACObserve(model, relation);
    RAC(self, accepted) = RACObserve(model, accepted);
    RAC(self, hot) = RACObserve(model, hot);
    RAC(self, likeUserAvatars) = [RACObserve(model, likeUserAvatars) map:^id(NSArray<NSString *> *likeUserAvatars) {
        return [likeUserAvatars bk_map:^id(NSString *avatar) {
            return [NSURL URLWithString:avatar];
        }];
    }];
    
    RAC(self, tag) = RACObserve(model, tag);
    
    @weakify(self);
    [[RACSignal merge:@[RACObserve(model, referClass),
                       RACObserve(model, referAcademy),
                       RACObserve(model, referName)]] subscribeNext:^(id x) {
        @strongify(self);
        if ([NSString notBlank:self.model.referName]) {
            NSMutableString *referStudent = [[NSMutableString alloc] init];
            if ([NSString notBlank:self.model.referClass]) {
                [referStudent appendFormat:@"%@ ", self.model.referClass];
            } else if([NSString notBlank:self.model.referAcademy]
                      && ![self.model.referAcademy isEqualToString:kAcademyNotSet]) {
                [referStudent appendFormat:@"%@ ", self.model.referAcademy];
            }
            [referStudent appendString:self.model.referName];
            self.referStudent = [referStudent copy];
        }
    }];
    
    RAC(self, backgroundColor) = [RACObserve(model, backgroundColor) map:^id(id value) {
        return [UIColor colorWithHexString:value];
    }];
    
    RAC(self, textColor) = [RACObserve(model, textColor) map:^id(id value) {
        return [UIColor colorWithHexString:value];
    }];
    
    RAC(self, bottomColor) = [RACObserve(model, bottomColor) map:^id(id value) {
        return [UIColor colorWithHexString:value];
    }];
    
}

#pragma mark - network delegate & datasource

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    LKPostModel *model = [apiManager fetchDataFromModel:LKPostModel.class];
    [self.model updateFromModel:model];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kPostAPIManagerParamsKeyId] = self.postId;
    return params;
}

- (void)toggleLike {
    if(self.relation != LKPostReleationAuthor) {
        [[LKLikeManager sharedInstance] likeItemId:self.postId
                                              type:kLKLikeItemTypeConfession
                                          isCancel:self.model.liked];
        NSMutableArray *tempArr = [self.model.likeUserAvatars mutableCopy];
        if (![tempArr containsObject:[User sharedInstance].avatarURL]) {
            [tempArr addObject:[User sharedInstance].avatarURL];
        }
        self.model.likeUserAvatars = [tempArr copy];
        if (self.model.liked) {
            [tempArr removeObject:[User sharedInstance].avatarURL];
            self.model.likeUserAvatars = [tempArr copy];
            self.model.likeCount--;
            self.model.liked = NO;
        } else {
            self.model.likeCount ++;
            self.model.liked = YES;
        }
    } else {
        [AppContext showMessage:@"不能给自己点赞哦~"];
    }
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.postAPIManager;
}

- (LKPostAPIManager *)postAPIManager {
    if (_postAPIManager == nil) {
        _postAPIManager = [LKPostAPIManager apiManagerByType:LKPostAPIManagerTypeGet];
        _postAPIManager.dataSource = self;
        _postAPIManager.delegate = self;
    }
    return _postAPIManager;
}

- (void)acceptConfession {
    self.model.accepted = YES;
    if (!self.model.tag) {
        self.model.tag = [LKPostViewModel acceptTextModel];
    }
}

- (BOOL)isEmpty {
    return ![NSString notBlank:self.model.content];
}

+ (LKTextModel *)acceptTextModel {
    LKTextModel *textModel = [[LKTextModel alloc] init];
    textModel.text = @"已接受";
    textModel.textColor = @"f05181";
    textModel.textSize = 11;
    textModel.hasBorder = YES;
    textModel.borderWidth = 1;
    textModel.borderColor = @"f05181";
    textModel.cornerRadius = 3;
    textModel.padding = @"{1, 2, 1, 2}";
    return  textModel;
}

- (void)postComment {
    self.model.commentCount++;
}
- (void)deleteComment {
    self.model.commentCount--;
}

@end
