//
//  LKTextAlertView.h
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKNoticeAlertContentView.h"
@interface LKTextAlertView : LKNoticeAlertContentView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
+ (instancetype)viewWithBlock:(void (^)())block;
@end
