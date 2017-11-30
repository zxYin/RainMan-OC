//
//  LKFlowModule.h
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
@interface LKFlowModule : NSObject

@end


@interface LKFlowService : LKService
- (RACSignal *)LKFlow_flowStringSignal:(NSDictionary *)params;
- (UIViewController *)LKFlow_flowViewController:(NSDictionary *)params;
@end
