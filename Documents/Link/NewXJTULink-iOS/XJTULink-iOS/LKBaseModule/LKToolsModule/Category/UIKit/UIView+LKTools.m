//
//  UIView+LKTools.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/4/29.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "UIView+LKTools.h"

@implementation UIView (LKTools)
- (UIImage *)lk_imageSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,self.contentScaleFactor);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
