//
//  RechargeBar.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/8.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RechargeBar;
@protocol RechareBarDelegate <NSObject>
- (void)buttonDidClick:(RechargeBar *) rechargeBar;
@end

@interface RechargeBar : UIView
+ (RechargeBar *)rechargeBar;

@property (weak,nonatomic) id<RechareBarDelegate> delegate;
@end
