//
//  UIViewController+Helper.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/11/2.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)
- (BOOL)isVisible;
- (CGFloat)realNavigationBarHeight;

- (BOOL)lk_forceTouchAvailable;
@end
