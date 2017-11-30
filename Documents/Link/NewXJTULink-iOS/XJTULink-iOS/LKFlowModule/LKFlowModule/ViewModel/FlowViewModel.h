//
//  FlowViewModel.h
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
@interface FlowViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSArray *itemTitles;
@property (nonatomic, copy, readonly) NSArray *itemValues;

@property (strong, nonatomic, readonly) NSArray *timeTitles;
@property (strong, nonatomic, readonly) NSArray *flowHistory;
@end
