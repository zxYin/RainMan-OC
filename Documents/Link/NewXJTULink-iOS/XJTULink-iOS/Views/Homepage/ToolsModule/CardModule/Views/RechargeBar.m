//
//  RechargeBar.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/8.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "RechargeBar.h"
@implementation RechargeBar


- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor grayColor];
}
- (void)drawRect:(CGRect)rect {
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    NSLog(@"");
//    [UIView drawLineFrom:CGPointMake(0, 0) to:CGPointMake(width, 0) withColor:LCOLOR_LIGHT_GRAY withWidth:1.0];
}
- (IBAction)buttonDidClick:(UIButton *)sender {
    [_delegate buttonDidClick:self];
}

+ (RechargeBar *)rechargeBar {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RechargeBar" owner:nil options:nil];
    RechargeBar *bar = nibs.lastObject;
    return bar;
}

@end
