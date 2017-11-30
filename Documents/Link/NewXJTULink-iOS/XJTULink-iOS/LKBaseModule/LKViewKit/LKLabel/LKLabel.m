//
//  LKLabel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/4/5.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKLabel.h"

@interface LKLabel ()

@property (nonatomic, strong) UIColor *normalColor;


@end

@implementation LKLabel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.padding = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.padding = UIEdgeInsetsZero;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.padding.left + self.padding.right,
                      size.height + self.padding.top + self.padding.bottom);
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.normalColor = self.backgroundColor;
    self.backgroundColor = self.highlightColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = self.normalColor;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = self.normalColor;
}

- (UIColor *)highlightColor {
    if (_highlightColor == nil) {
        _highlightColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return _highlightColor;
}

@end
