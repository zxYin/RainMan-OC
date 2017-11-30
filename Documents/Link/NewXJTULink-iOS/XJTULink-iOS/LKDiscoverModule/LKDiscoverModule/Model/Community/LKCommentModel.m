//
//  ConfessionCommentModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentModel.h"
#import "MTLValueTransformer+Community.h"
@implementation LKCommentModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commentId":@"id",
             @"content":@"content",
             @"timestamp":@"timestamp",
             @"liked":@"is_like",
             @"likeCount":@"like_count",
             @"type":@"type",
             @"remark":@"remark",
             @"user":@"user",
             @"referUser":@"refer_user",
             };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerOfCommentType];
}


@end
