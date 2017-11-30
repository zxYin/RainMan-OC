//
//  AppMediator+LKFlowModule.h
//  LKMediator
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
@interface AppMediator (LKFlowModule)
- (RACSignal *)LKFlow_flowStringSignal;

- (void)LKFlow_flowViewController:(void(^)(UIViewController *flowViewController))block;
@end
