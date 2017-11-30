//
//  UIImage+LKExpansion.h
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LKExpansion)
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)lk_imageScaledToSize:(CGSize)size;
+ (UIImage *)lk_imageScaledFromImage:(UIImage *)image toSize:(CGSize)size;
- (UIImage *)lk_imageForRect:(CGRect)rect;
@end
