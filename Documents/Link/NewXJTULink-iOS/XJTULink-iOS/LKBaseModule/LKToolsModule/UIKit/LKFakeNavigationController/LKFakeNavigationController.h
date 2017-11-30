//
//  LKFakeNavigationController.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKFakeNavigationController : UIView
//@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@end




@interface UIViewController (LKFakeNavigationController)
@property (nonatomic, strong, readonly) LKFakeNavigationController *lk_fakeNavigationController;
@end
