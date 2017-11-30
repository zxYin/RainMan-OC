//
//  ClubModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubModel.h"
#import "MTLValueTransformer+LKModel.h"

@implementation ClubModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"clubId":@"club_id",
            @"name":@"name",
            @"summary":@"summary",
            @"titles":@"titles",
            @"showType":@"show_type",
            @"webURL":@"url",
            @"images":@"images",
            @"type":@"type",
            @"locale":@"locale",
            @"isAllowApply":@"is_allow_apply",
            @"applyURL":@"apply_url",
            @"shareURLString":@"share_url",
            @"introduction":@"introduction",
            @"departmentType":@"department.type",
            @"departmentURL":@"department.url",
            @"departments":@"department.departments",
    };
}

+ (NSValueTransformer *)clubIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

+ (NSValueTransformer *)departmentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[DepartmentModel class]];
}

+ (NSValueTransformer *)showTypeJSONTransformer {
    return [MTLValueTransformer transformerOfPageShowType];
}

+ (NSValueTransformer *)departmentTypeJSONTransformer {
    return [MTLValueTransformer transformerOfPageShowType];
}


@end
