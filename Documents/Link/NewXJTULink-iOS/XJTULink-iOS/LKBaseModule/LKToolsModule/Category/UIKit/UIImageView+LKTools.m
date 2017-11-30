//
//  UIImageView+LKTools.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "UIImageView+LKTools.h"
#import "UIImage+LKExpansion.h"
@implementation UIImageView (LKTools)
- (void)lk_setTintColor:(UIColor *)tintColor {
    self.image = [self.image imageWithTintColor:tintColor];
}

- (void)lk_circleImageView {
    UIGraphicsBeginImageContext(self.image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    //在圆区域内画出image原图
    [self.image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    //生成新的image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newImage;
    
}
@end
