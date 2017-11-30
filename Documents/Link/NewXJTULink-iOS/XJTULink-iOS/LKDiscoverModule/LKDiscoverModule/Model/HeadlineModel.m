//
//  HeadlineModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "HeadlineModel.h"

@implementation HeadlineModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"articleId":@"article_id",
             @"title":@"title",
             @"url":@"url",
             @"clubId":@"club_id",
             @"type":@"type",
             @"imageURL":@"image",
             };
}

+ (NSValueTransformer *)clubIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}


+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        HeadlineType type = kHeadlineTypeWeb;
        if (![value isKindOfClass:[NSString class]]) {
            return @(type);
        }
        
        NSString *typeString = [(NSString *)value lowercaseString];
        if ([typeString isEqualToString:@"web"]) {
            type = kHeadlineTypeWeb;
        } else if ([typeString isEqualToString:@"article"]) {
             type = kHeadlineTypeArticle;
        } else if([typeString isEqualToString:@"club"]) {
            type = kHeadlineTypeClub;
        }
        return @(type);
    }];
}
@end
