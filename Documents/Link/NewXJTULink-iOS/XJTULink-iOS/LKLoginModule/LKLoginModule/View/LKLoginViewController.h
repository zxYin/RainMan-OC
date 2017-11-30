//
//  LKLoginViewController.h
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKWebBrowser.h"
@class LKLoginViewController;
@protocol LKLoginViewControllerDelegate <NSObject>
- (void)loginViewController:(LKLoginViewController *)loginViewController dismissWithBlock:(void (^)())block finish:(BOOL)finish;
@end


@interface LKLoginViewController : LKWebBrowser
@property (nonatomic, weak) id<LKLoginViewControllerDelegate> delegate;
- (instancetype)initWithCallback:(void (^)())block;
@end
