//
//  YLAlertPanelButtonImageView.m
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAlertPanelButtonImageView.h"

@interface YLAlertPanelButtonImageView()
@property (nonatomic, strong) UIColor *normalColor;
@end

@implementation YLAlertPanelButtonImageView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.normalColor = self.backgroundColor;
    self.backgroundColor = self.highlightColor;
    NSLog(@"touchesBegan");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = self.normalColor;
    NSLog(@"touchesEnded");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = self.normalColor;
    NSLog(@"touchesCancelled");
}

- (UIColor *)highlightColor {
    if (_highlightColor == nil) {
        _highlightColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return _highlightColor;
}
@end
