//
//  LKTextAlertView.m
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKTextAlertView.h"
#import "LKNoticeAlert.h"
@interface LKTextAlertView()

@end

@implementation LKTextAlertView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClick:)];
    [self addGestureRecognizer:tap];
}

- (void)viewDidClick:(UIGestureRecognizer *)recognizer {
    if (self.block) {
        self.block();
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action];
    }
#pragma clang diagnostic pop  
    
    [[LKNoticeAlert currentNoticeAlert] dismiss];
}


+ (instancetype)viewWithBlock:(void (^)())block {
    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"LKTextAlertView" owner:nil options:nil];
    LKTextAlertView *view = [views firstObject];
    view.block = block;
    return [views firstObject];
}
@end
