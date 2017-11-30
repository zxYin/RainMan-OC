//
//  LKNoticeAlertContentView.m
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNoticeAlertContentView.h"

@implementation LKNoticeAlertContentView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

+ (instancetype)viewWithBlock:(void (^)())block {
    LKNoticeAlertContentView *contentView = [[LKNoticeAlertContentView alloc] init];
    contentView.block = block;
    return contentView;
}

+ (instancetype)viewWithTarget:(id)target action:(SEL)action {
    LKNoticeAlertContentView *contentView = [[LKNoticeAlertContentView alloc] init];
    contentView.target = target;
    contentView.action = action;
    return contentView;
}

@end
