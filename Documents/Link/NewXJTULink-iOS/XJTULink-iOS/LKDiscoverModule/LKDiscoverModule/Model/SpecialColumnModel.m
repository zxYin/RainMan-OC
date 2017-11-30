//
//  SpecialColumnModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SpecialColumnModel.h"

@implementation SpecialColumnModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"items":@"urls",
             @"title":@"title",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SingleURLModel class]];
}

@end
