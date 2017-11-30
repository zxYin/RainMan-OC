//
//  UIViewController+LKStatistics.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UIViewController+LKStatistics.h"
#import "RTRootNavigationController.h"
#import "UMMobClick/MobClick.h"

static NSSet<Class> *HookWhiteSet;

@implementation UIViewController (LKStatistics)
+ (void)load {
    
    [self setupWhiteSet];

    [NSObject methodSwizzlingWithTarget:@selector(viewDidAppear:)
                                  using:@selector(swizzling_LKStatistics_viewDidAppear:)
                               forClass:[self class]];
    
    [NSObject methodSwizzlingWithTarget:@selector(viewDidDisappear:)
                                  using:@selector(swizzling_LKStatistics_viewDidDisappear:)
                               forClass:[self class]];
}


// 写成单独类方法是方便动态更新
+ (NSArray *)whiteArray {
    return @[@"UITabBarController",
             
             // 导航栏相关
             @"UINavigationController",
             @"RTRootNavigationController",
             @"RTContainerNavigationController",
             @"RTContainerController",
             
             // Mail相关
             @"MFMailComposeInternalViewController",
             @"MFMailComposeRemoteViewController",
             
             // 键盘相关
             @"UIInputWindowController",
             @"UICompatibilityInputViewController",
             ];
}

+ (void)setupWhiteSet {
    NSMutableSet *whiteSet = [[NSMutableSet alloc] init];
    [[self whiteArray]
     enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [whiteSet addObject:(NSClassFromString(obj))];
     }];
    HookWhiteSet = [whiteSet copy];
}


- (BOOL)isNeedIgnore{
    if ([HookWhiteSet containsObject:[self class]]) {
        return YES;
    }
    return NO;
}

- (void)swizzling_LKStatistics_viewDidAppear:(BOOL)animated {
    [self swizzling_LKStatistics_viewDidAppear:animated];
    
    if ([self isNeedIgnore]) { return; }
    
    NSString *className = NSStringFromClass([self class]);
    [MobClick beginLogPageView:className];
    
    NSLog(@"[LKStatistics-UIViewController][Appear][%@]",className);
    
}

- (void)swizzling_LKStatistics_viewDidDisappear:(BOOL)animated {
    [self swizzling_LKStatistics_viewDidDisappear:animated];
    if ([self isNeedIgnore]) { return; }
    
    NSString *className = NSStringFromClass([self class]);
    [MobClick endLogPageView:className];
    
    NSLog(@"[LKStatistics][Disappear][%@]",className);
}

@end

@interface UINavigationController (LKStatistics)

@end

@implementation UINavigationController (LKStatistics)

+ (void)load {
    [NSObject methodSwizzlingWithTarget:@selector(pushViewController:animated:)
                                  using:@selector(swizzling_LKStatistics_pushViewController:animated:)
                               forClass:[self class]];
    

}

- (void)swizzling_LKStatistics_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topViewController = self.topViewController;
    
    if ([topViewController isKindOfClass:[RTContainerController class]]) {
        topViewController = ((RTContainerController *)topViewController).contentViewController;
    }
    
    UIViewController *presentViewController = viewController;
    if ([presentViewController isKindOfClass:[RTContainerController class]]) {
        presentViewController = ((RTContainerController *)presentViewController).contentViewController;
    }
    
    
    NSString *hostClassName = NSStringFromClass([topViewController class]);
    NSString *presentClassName = NSStringFromClass([presentViewController class]);
    NSLog(@"[LKStatistics][%@][Push][%@]",hostClassName,presentClassName);
    
    [self swizzling_LKStatistics_pushViewController:viewController animated:animated];
}



@end
