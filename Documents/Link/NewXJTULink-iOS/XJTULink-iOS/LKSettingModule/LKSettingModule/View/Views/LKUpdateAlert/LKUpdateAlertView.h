//
//  LKUpdateView.h
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKNoticeAlertContentView.h"
@interface LKUpdateAlertView : LKNoticeAlertContentView
@property (nonatomic, copy) void (^updateBlock)();
@property (nonatomic, copy) void (^skipBlock)();

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

+ (instancetype)viewWithUpdateBlock:(void (^)())block skipBlock:(void (^)())skipBlock;
@end
