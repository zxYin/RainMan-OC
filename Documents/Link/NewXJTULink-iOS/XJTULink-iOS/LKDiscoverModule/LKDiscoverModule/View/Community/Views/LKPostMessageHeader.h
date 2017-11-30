//
//  ConfessionNewsMessageHeader.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTouchableView.h"
static CGFloat ConfessionNewsMessageHeaderHeight = 45;
@interface LKPostMessageHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet LKTouchableView *backgroundView;

+ (instancetype)headerView;
@end
