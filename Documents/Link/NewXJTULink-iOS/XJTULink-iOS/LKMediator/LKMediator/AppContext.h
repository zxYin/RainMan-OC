//
//  AppContext.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LKTabBarItem) {
    LKTabBarItemCurrent = -1,
    LKTabBarItemHomePage = 0,
    LKTabBarItemCourse,
    LKTabBarItemDiscover,
    LKTabBarItemMine,
};

////////////////////////////////////////////////////////////////////////////////////////

@interface AppContext : NSObject
@property (nonatomic, copy) NSString *serverURL;

+ (instancetype)sharedInstance;

+ (LKTabBarItem)tabBarItemByString:(NSString *)item;
+ (UIWindow *)lastWindow;
- (UIViewController *)currentViewController;
- (UITabBarController *)currentTabBarController;
- (UINavigationController *)currentNavigationController;

- (UITabBarController *)tabBarControllerAtItem:(LKTabBarItem)item;
- (UINavigationController *)navigationControllerOfTabBarControllerAtItem:(LKTabBarItem)item;

+ (void)showMessage:(NSString *)msg;
+ (void)showMessage:(NSString *)msg time:(NSInteger)time;
+ (void)showError:(NSString *)msg;
+ (void)showError:(NSString *)msg time:(NSInteger)time;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showProgressFinishHUDWithMessage:(NSString *)msg;
+ (void)showProgressFailHUDWithMessage:(NSString *)msg;
+ (void)showProgressHUDWithMessage:(NSString *)msg image:(UIImage *)image;
+ (void)showProgressHUDWithMessage:(NSString *)msg image:(UIImage *)image time:(NSInteger)time;

+ (void)showProgressLoading;
+ (void)showProgressLoadingWithMessage:(NSString *)message;
+ (void)dismissProgressLoading;
@end

