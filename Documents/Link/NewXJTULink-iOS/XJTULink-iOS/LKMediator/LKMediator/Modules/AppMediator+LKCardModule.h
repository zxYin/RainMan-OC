//
//  AppMediator+LKCardModule.h
//  LKMediator
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"

@interface AppMediator (LKCardModule)
- (RACSignal *)LKCard_balanceStringSignal;
- (void)LKCard_cardViewController:(void(^)(UIViewController *cardViewController))block;
- (void)LKCard_transferViewController:(void(^)(UIViewController *transferViewController))block;
@end
