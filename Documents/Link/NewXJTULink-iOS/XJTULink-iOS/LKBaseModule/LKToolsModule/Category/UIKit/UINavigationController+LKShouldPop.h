//
//  UINavigationController+LKShouldPop.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LKBackButtonHandlerProtocol <NSObject>
@optional
-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UINavigationController (LKShouldPop)

@end
