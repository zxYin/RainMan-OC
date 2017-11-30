//
//  LKCardModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
@interface LKCardModule : NSObject

@end

@interface LKCardService : LKService
- (RACSignal *)LKCard_balanceStringSignal:(NSDictionary *)params;
- (UIViewController *)LKCard_cardViewController:(NSDictionary *)params;
- (UIViewController *)LKCard_transferViewController:(NSDictionary *)params;
@end
