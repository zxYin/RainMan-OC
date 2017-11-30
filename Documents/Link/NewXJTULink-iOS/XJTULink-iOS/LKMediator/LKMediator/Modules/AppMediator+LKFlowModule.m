//
//  AppMediator+LKFlowModule.m
//  LKMediator
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKFlowModule.h"
NSString * const kAppMediatorFlowModule= @"LKFlowModule";

NSString * const kAppMediatorFlowServiceFlowStringSignal = @"flowStringSignal";
NSString * const kAppMediatorFlowServiceFlowViewController = @"flowViewController";

@implementation AppMediator (LKFlowModule)

+ (void)load {
    LKModule(@"flow"    , kAppMediatorFlowModule);
    LKRoute(@"/"        , kAppMediatorFlowServiceFlowViewController, kAppMediatorFlowModule);
}

- (RACSignal *)LKFlow_flowStringSignal {
    return [[self performAction:kAppMediatorFlowServiceFlowStringSignal
                                   onModule:kAppMediatorFlowModule
                                     params:nil]
            safeType:[RACSignal class]];
}

- (UIViewController *)LKFlow_flowViewController {
    return [[self performAction:kAppMediatorFlowServiceFlowViewController
                       onModule:kAppMediatorFlowModule
                         params:nil]
            safeType:[UIViewController class]];
}


- (void)LKFlow_flowViewController:(void(^)(UIViewController *flowViewController))block {
    if (block) {
        [[self performAction:kAppMediatorFlowServiceFlowViewController
                    onModule:kAppMediatorFlowModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
}
@end
