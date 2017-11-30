//
//  UINavigationController+LKShouldPop.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UINavigationController+LKShouldPop.h"

@implementation UINavigationController (LKShouldPop)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    id vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        
        // fix bugs if return NO
        BOOL isHidden = self.navigationBar.hidden;
        [self setNavigationBarHidden:!isHidden animated:NO];
        [self setNavigationBarHidden:isHidden animated:NO];
    }
    
    return shouldPop;
}

@end
