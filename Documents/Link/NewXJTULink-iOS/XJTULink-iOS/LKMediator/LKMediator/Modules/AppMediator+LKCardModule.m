//
//  AppMediator+LKCardModule.m
//  LKMediator
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKCardModule.h"
NSString * const kAppMediatorCardModule= @"LKCardModule";

NSString * const kAppMediatorCardServiceBalanceStringSignal = @"balanceStringSignal";
NSString * const kAppMediatorCardServiceCardViewController = @"cardViewController";
NSString * const kAppMediatorCardServiceTransferViewController = @"transferViewController";

@implementation AppMediator (LKCardModule)

+ (void)load {
    LKModule(@"card"    , kAppMediatorCardModule);
    LKRoute(@"/"        , kAppMediatorCardServiceCardViewController     , kAppMediatorCardModule);
    LKRoute(@"/transfer/", kAppMediatorCardServiceTransferViewController , kAppMediatorCardModule);
    
}

- (RACSignal *)LKCard_balanceStringSignal {
    return [[self performAction:kAppMediatorCardServiceBalanceStringSignal
                      onModule:kAppMediatorCardModule
                        params:nil]
             safeType:[RACSignal class]];
}


- (void)LKCard_cardViewController:(void(^)(UIViewController *cardViewController))block {
    if (block) {
        [[self performAction:kAppMediatorCardServiceCardViewController
                       onModule:kAppMediatorCardModule
                         params:@{kAppMediatorFinishUsingBlock:[block copy]}]
            safeType:[UIViewController class]];
    }
}

- (void)LKCard_transferViewController:(void(^)(UIViewController *transferViewController))block {
    if (block) {
        [[self performAction:kAppMediatorCardServiceTransferViewController
                    onModule:kAppMediatorCardModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
}
@end
