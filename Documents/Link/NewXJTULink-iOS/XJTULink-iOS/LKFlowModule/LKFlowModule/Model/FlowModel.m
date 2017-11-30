//
//  FlowModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/24.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "FlowModel.h"
@implementation FlowHistoryItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"inFlow":@"inflow",
             @"outFlow":@"outflow",
             @"charge":@"charge",
             @"time":@"time",
             };
}

@end


@implementation FlowModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"inFlow":@"flow_info.inflow",
            @"outFlow":@"flow_info.outflow",
            @"charge":@"charge",
            @"ip":@"ip",
            @"status":@"state",
            @"historyItemModels":@"history",
    };
}

+ (NSValueTransformer *)historyItemModelsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FlowHistoryItemModel class]];
}
@end
