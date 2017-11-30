//
//  LKNoticeAlert.m
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNoticeAlert.h"
#import "LKUpdateAlertView.h"
#import "LKTextAlertView.h"
#import "LKImageAlertView.h"
#import "LKNoticeAlertContentView.h"

@interface LKNoticeAlert()
@property (strong, nonatomic) UIWindow *window;
@end
@implementation LKNoticeAlert
- (instancetype)initWithContentView:(UIView *)view {
    self = [super init];
    if (self) {
        self.contentView = view;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.closeButton];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidClick:)];
    [self.view addGestureRecognizer:tap];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame;
    
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    __block CGFloat maxHeight = 0;
    [[self.contentView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxHeight < obj.frame.origin.y + obj.frame.size.height) {
            maxHeight = obj.frame.origin.y + obj.frame.size.height;
        }
    }];
    
    frame = self.contentView.frame;
    frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.0;
    frame.origin.y = CGRectGetMidY(self.view.frame) - CGRectGetHeight(frame) * 2.0 / 3.0;
    frame.size.height = maxHeight + 15;
    self.contentView.frame = frame;
    
    
    frame = self.closeButton.frame;
    frame.origin.y = CGRectGetMaxY(self.contentView.frame) + 30;
    frame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(frame) / 2.0 ;
    self.closeButton.frame = frame;
    
}


- (void)show {
    [self setupNewWindow];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
    
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)())completion {
//    CGRect frame = self.tableView.frame;
//    NSLog(@"ORIGIN:%@",NSStringFromCGRect(frame));
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
//    NSLog(@"FRAME: %@",NSStringFromCGRect(frame));
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        //        self.view.alpha = 1;
//        NSLog(@"ORIGIN 2:%@",NSStringFromCGRect(self.tableView.frame));
//        self.view.backgroundColor = [UIColor clearColor];
//        self.tableView.frame = frame;
//    } completion:^(BOOL finished) {
    self.window = nil;
//        if (completion) {
//            completion();
//        }
//        
//    }];
    
}


- (void)backgroundViewDidClick:(UIGestureRecognizer *)tap {
    [self dismiss];
}
- (void)setupNewWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = self;
    window.opaque = NO;
    self.window = window;
    
    [window makeKeyAndVisible];
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _closeButton.userInteractionEnabled = NO;
        [_closeButton setImage:[UIImage imageNamed:@"notice_close_button"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

+ (LKNoticeAlert *)currentNoticeAlert {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = currentWindow.rootViewController;
    if ([vc isKindOfClass:[LKNoticeAlert class]]) {
        return (LKNoticeAlert *)vc;
    } else {
        return nil;
    }
}

@end
