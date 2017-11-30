//
//  UILabel+LKTextModel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/28.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "UILabel+LKTextModel.h"
#import "Chameleon.h"
#import "Foundation+LKTools.h"
#import <Masonry/Masonry.h>
#import "LKLabel.h"
#import "UIView+YLAutoLayoutHider.h"
@implementation UILabel (LKTextModel)
- (void)lk_setTextWithModel:(LKTextModel *)model {
    if (model == nil) {
        self.text = nil;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
        [self yl_setHidden:YES forType:YLHiddenTypeHorizontal];
        return;
    }
    [self yl_setHidden:NO forType:YLHiddenTypeHorizontal];
    if (![model isKindOfClass:[LKTextModel class]]) {
        return;
    }
    
    self.text = model.text;
    
    UIColor *color;
    
    color = [UIColor colorWithHexString:model.textColor];
    if (color) {
        self.textColor = color;
    }
    
    if (model.textSize > 0) {
        self.font = [UIFont systemFontOfSize:model.textSize];
    }
    
    if (model.hasBorder) {
        self.layer.borderColor = [UIColor colorWithHexString:model.borderColor].CGColor;
        self.layer.borderWidth = model.borderWidth;
    }
    
    self.layer.cornerRadius = model.cornerRadius;
    
    if ([NSString notBlank:model.padding]) {
        UIEdgeInsets padding = UIEdgeInsetsFromString(model.padding);
        if ([self isKindOfClass:[LKLabel class]]) {
            ((LKLabel *)self).padding = padding;
        } else {
            [self sizeToFit];
            CGFloat height = self.frame.size.height + padding.top + padding.bottom;
            CGFloat width = self.frame.size.width + padding.right + padding.left;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
        }
        self.textAlignment = NSTextAlignmentCenter;
    }
    self.clipsToBounds = YES;
}
@end
