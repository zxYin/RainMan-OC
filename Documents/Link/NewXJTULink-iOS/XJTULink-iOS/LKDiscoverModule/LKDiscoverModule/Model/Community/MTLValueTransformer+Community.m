//
//  MTLValueTransformer+ConfeddsionModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "MTLValueTransformer+Community.h"
#import "LKPostModel.h"
#import "LKCommentModel.h"
@implementation MTLValueTransformer (Community)
+ (instancetype)transformerOfConfessionReleation {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        LKPostReleation type = LKPostReleationDefault;
        if (![value isKindOfClass:[NSString class]]) {
            return @(type);
        }
        
        NSString *typeString = [(NSString *)value lowercaseString];
        if ([typeString isEqualToString:@"author"]) {
            type = LKPostReleationAuthor;
        } else if([typeString isEqualToString:@"target"]) {
            type = LKPostReleationTarget;
        }
        return @(type);
    }];
}

+ (instancetype)transformerOfCommentType {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        CommentType type = CommentTypeDefault;
        if (![value isKindOfClass:[NSString class]]) {
            return @(type);
        }
        
        NSString *typeString = [(NSString *)value lowercaseString];
        if ([typeString isEqualToString:@"mosaic"]) {
            type = CommentTypeMosaic;
        }
        return @(type);
    }];
}

@end
