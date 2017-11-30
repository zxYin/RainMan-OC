//
//  UIViewController+Helper.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/11/2.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)
- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window);
}


- (CGFloat)realNavigationBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
    + CGRectGetHeight(self.navigationController.navigationBar.frame);
}


- (BOOL)lk_forceTouchAvailable {
    return self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
}

@end
