//
//  LKNoticeAlert.h
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTextAlertView.h"
#import "LKImageAlertView.h"


@interface LKNoticeAlert : UIViewController
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeButton;
- (void)show;
- (void)dismiss;
+ (LKNoticeAlert *)currentNoticeAlert;


- (instancetype)initWithContentView:(UIView *)view;
@end
