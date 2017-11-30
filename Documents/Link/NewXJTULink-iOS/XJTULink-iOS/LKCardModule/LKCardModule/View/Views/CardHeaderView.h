//
//  LKCardHeader.h
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat CardHeaderViewHeight = 165;
@interface CardHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

+ (instancetype)cardHeaderView;
@end
