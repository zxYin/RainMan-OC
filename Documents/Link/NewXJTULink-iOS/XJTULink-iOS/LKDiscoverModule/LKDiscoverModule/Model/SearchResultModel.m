//
//  SearchResultModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"clubModels":@"clubs",
             @"articleModels":@"articles",
             };
}

+ (NSValueTransformer *)clubModelsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ClubModel class]];
}
+ (NSValueTransformer *)articleModelsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SingleURLModel class]];
}

@end
