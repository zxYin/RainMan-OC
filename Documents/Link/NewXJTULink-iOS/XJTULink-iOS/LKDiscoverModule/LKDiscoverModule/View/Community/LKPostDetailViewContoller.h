//
//  ConfessionDetailViewContoller.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPostViewModel.h"
#import "UINavigationController+LKShouldPop.h"
typedef void (^ConfessionDidDeleteBlock)(LKPostViewModel *model);

@interface LKPostDetailViewContoller : UIViewController<LKBackButtonHandlerProtocol>

@property (nonatomic, copy)ConfessionDidDeleteBlock didDeleteBlock;

- (instancetype)initWithViewModel:(LKPostViewModel *)viewModel;

@end
