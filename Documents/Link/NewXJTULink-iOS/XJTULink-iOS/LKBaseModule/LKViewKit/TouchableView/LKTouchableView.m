//
//  LKTouchableView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKTouchableView.h"
@interface LKTouchableView()
@property (nonatomic, strong) UIColor *normalColor;
@end
@implementation LKTouchableView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.normalColor = self.backgroundColor;
    self.backgroundColor = self.highlightColor?:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = self.normalColor;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = self.normalColor;
}
@end
