//
//  LKNoticeAlertContentView.h
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LKNoticeAlert;
typedef BOOL (^LKNoticeAlertBlock) ();

@interface LKNoticeAlertContentView : UIView
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@property (copy, nonatomic) void (^block)();
+ (instancetype)viewWithBlock:(void (^)())block;
+ (instancetype)viewWithTarget:(id)target action:(SEL)action;
@end
