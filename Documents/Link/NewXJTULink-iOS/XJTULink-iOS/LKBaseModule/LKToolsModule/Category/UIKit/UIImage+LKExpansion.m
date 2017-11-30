//
//  UIImage+LKExpansion.m
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UIImage+LKExpansion.h"

@implementation UIImage (LKExpansion)
- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)lk_imageScaledToSize:(CGSize)size {
    return [UIImage lk_imageScaledFromImage:self toSize:size];
}

+ (UIImage *)lk_imageScaledFromImage:(UIImage *)image toSize:(CGSize)size {
    if (image == nil) {
        return nil;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)lk_imageForRect:(CGRect)rect {
    CGImageRef ref = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:ref];
}

@end
