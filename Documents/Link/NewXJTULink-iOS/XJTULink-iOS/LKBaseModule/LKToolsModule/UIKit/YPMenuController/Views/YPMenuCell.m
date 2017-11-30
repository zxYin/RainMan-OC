//
//  YPMenuCell.m
//  MenuTest
//
//  Created by Yunpeng on 16/4/23.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YPMenuCell.h"

@implementation YPMenuCell

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context,[UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, YPMenuCellHeight);
    CGContextAddLineToPoint(context, [UIScreen mainScreen].bounds.size.width, YPMenuCellHeight);
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.backgroundColor = [UIColor redColor];
//    } else {
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    
}

@end
