//
//  LKLoginModule.m
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLoginModule.h"
#import "CASLoginAPIManager.h"
#import "AppContext.h"
#import "LKLoginViewController.h"
#import "LKLogoutAPIManager.h"
#import "User+Auth.h"
#import "Foundation+LKTools.h"
@implementation LKLoginModule

@end
@interface LKLoginService()<LKLoginViewControllerDelegate>
@property (nonatomic, assign, getter=isDisplaying) BOOL displaying;
@property (nonatomic, strong) UIWindow *window;
@end
@implementation LKLoginService
- (id)LKLogin_casLoginAPIManager:(NSDictionary *)params {
    return [[CASLoginAPIManager alloc] init];
}

- (id)LKLogin_logoutAPIManager:(NSDictionary *)params {
    return [[LKLogoutAPIManager alloc] init];
}

- (id)LKLogin_presentLoginViewController:(NSDictionary *)params {
    if ([[LKServicePool sharedInstance] containsType:LKLoginService.class]) {
        // 已经在登录页面，不再弹出登录
        return nil;
    }
    [[LKServicePool sharedInstance] registerService:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LKLoginViewController *loginViewController =
        [[LKLoginViewController alloc] initWithCallback:params[@"callback"]];
        loginViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        self.window.rootViewController = navController;
        
        [self.window makeKeyAndVisible];
        if([params boolForKey:@"animation" defaultValue:YES]) {
            CGRect originNavBarFrame = navController.navigationBar.frame;
            CGRect navBarFrame = originNavBarFrame;
            navBarFrame.origin.y = -navBarFrame.size.height;
            navController.navigationBar.frame = navBarFrame;
            
            CGRect originLoginVCFrame = loginViewController.view.frame;
            CGRect loginVCFrame = originLoginVCFrame;
            loginVCFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
            loginViewController.view.frame = loginVCFrame;
            
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                navController.navigationBar.frame = originNavBarFrame;
                loginViewController.view.frame = originLoginVCFrame;
            } completion:^(BOOL finished) {
                NSString *message = [params stringForKey:@"message"];
                if ([NSString notBlank:message]) {
                    [AppContext showMessage:message time:3];
                }
            }];
        }

    });
    
    
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navController animated:YES completion:nil];
    return nil;
}


- (void)loginViewController:(LKLoginViewController *)loginViewController dismissWithBlock:(void (^)())block finish:(BOOL)finish {
    self.displaying = NO;
    if (finish) {
        if (block) {
            block();
        }
    }
    
    CGRect navBarFrame = loginViewController.navigationController.navigationBar.frame;
    navBarFrame.origin.y = -navBarFrame.size.height;
    
    CGRect loginVCFrame = loginViewController.view.frame;
    loginVCFrame.origin.y = [UIScreen mainScreen].bounds.size.height + 100.0;
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loginViewController.navigationController.navigationBar.frame = navBarFrame;
        loginViewController.view.frame = loginVCFrame;
    } completion:^(BOOL finished) {
        [self.window resignKeyWindow];
        [[LKServicePool sharedInstance] removeService:self];
    }];
}


- (UIWindow *)window {
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelNormal;
        _window.backgroundColor = [UIColor clearColor];
        _window.opaque = NO;
    }
    return _window;
}

@end
