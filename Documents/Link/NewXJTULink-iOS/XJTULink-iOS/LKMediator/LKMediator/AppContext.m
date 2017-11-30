//
//  AppContext.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppContext.h"
#import "RKDropdownAlert.h"
#import "SVProgressHUD.h"

@interface AppContext()
@end
@implementation AppContext

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppContext *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppContext alloc] init];
    });
    return instance;
}

+ (LKTabBarItem)tabBarItemByString:(NSString *)item {
    NSString *lowercaseItem = [item lowercaseString];
    
    if ([lowercaseItem isEqualToString:@"current"]) {
        return LKTabBarItemCurrent;
    } else if ([lowercaseItem isEqualToString:@"homepage"]) {
        return LKTabBarItemHomePage;
    } else if([lowercaseItem isEqualToString:@"course"]) {
        return LKTabBarItemCourse;
    } else if([lowercaseItem isEqualToString:@"discover"]) {
        return LKTabBarItemDiscover;
    } else if([lowercaseItem isEqualToString:@"mine"]) {
        return LKTabBarItemMine;
    } else {
        // default
        return LKTabBarItemHomePage;
    }
}



- (UIViewController *)currentViewController {
    UINavigationController *navController = [self currentNavigationController];
    return navController.topViewController;
}

- (UITabBarController *)currentTabBarController {
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *rootVC = mainWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)rootVC;
    }
    return nil;
}

- (UINavigationController *)currentNavigationController {
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *rootVC = mainWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class] ]) {
        return (UINavigationController *)rootVC;
    } else if([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootVC;
        UIViewController *selectedVC = tabBarController.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectedVC;
        }
    }
    return nil;
}

- (UITabBarController *)tabBarControllerAtItem:(LKTabBarItem)item {
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows firstObject];
    UIViewController *rootVC = mainWindow.rootViewController;
    if (![rootVC isKindOfClass:UITabBarController.class]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LKMain" bundle:nil];
        mainWindow.rootViewController = [storyboard instantiateInitialViewController];
        rootVC = mainWindow.rootViewController;
    }
    
    UITabBarController *tabBarController = (UITabBarController *)rootVC;
    
    UIViewController *selectedVC = tabBarController.selectedViewController;
    if ([selectedVC isKindOfClass:UINavigationController.class]) {
        [(UINavigationController *)selectedVC popToRootViewControllerAnimated:NO];
    }
    
    NSInteger targetItem = item;
    if (item >= [tabBarController.viewControllers count]) {
        targetItem = [tabBarController.viewControllers count] - 1;
    }
    
    [tabBarController setSelectedIndex:targetItem];
    NSLog(@"TabbarController:%@",tabBarController);
    return tabBarController;
}

- (UINavigationController *)navigationControllerOfTabBarControllerAtItem:(LKTabBarItem)item {
    if (item == LKTabBarItemCurrent) {
        return [self currentNavigationController];
    }
    
    UITabBarController *tabBarController = [self tabBarControllerAtItem:item];
    UIViewController *rootVC = tabBarController.selectedViewController;
    if ([rootVC isKindOfClass:UINavigationController.class]) {
        NSLog(@"UINavigationController:%@",rootVC);
        return (UINavigationController *)rootVC;
    }
    NSLog(@"[warning][navigationControllerOfTabBarControllerAtItem]返回nil");
    return nil;
    
}

+ (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (void)showMessage:(NSString *)msg {
    [RKDropdownAlert title:msg];
}
+ (void)showMessage:(NSString *)msg time:(NSInteger)time {
    [RKDropdownAlert title:msg time:time];
}

+ (void)showError:(NSString *)msg {
    [RKDropdownAlert title:msg backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
}

+ (void)showError:(NSString *)msg time:(NSInteger)time {
    [RKDropdownAlert title:msg backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:time];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
#pragma clang diagnostic pop
}

+ (void)showProgressFinishHUDWithMessage:(NSString *)msg {
    [self showProgressHUDWithMessage:msg image:[UIImage imageNamed:@"hud_icon_checkmark"]];
}

+ (void)showProgressFailHUDWithMessage:(NSString *)msg {
    [self showProgressHUDWithMessage:msg image:[UIImage imageNamed:@"hud_icon_error"]];
}
+ (void)showProgressHUDWithMessage:(NSString *)msg image:(UIImage *)image {
    [self showProgressHUDWithMessage:msg image:image time:3];
}

+ (void)showProgressHUDWithMessage:(NSString *)msg image:(UIImage *)image time:(NSInteger)time {
    [self dismissProgressLoading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showImage:image status:msg];
}

+ (void)showProgressLoading {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

+ (void)showProgressLoadingWithMessage:(NSString *)message {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismissProgressLoading {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD dismiss];
}
@end
