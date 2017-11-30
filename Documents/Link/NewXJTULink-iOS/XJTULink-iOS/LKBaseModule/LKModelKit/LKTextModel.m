//
//  LKTextModel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKTextModel.h"

@implementation LKTextModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"text":@"text",
        @"textColor":@"text_color",
        @"textSize":@"text_size",
        @"hasBorder":@"has_border",
        @"cornerRadius":@"corner_radius",
        @"borderWidth":@"border_width",
        @"borderColor":@"border_color",
        @"backgroundColor":@"bg_color",
        @"padding":@"padding",
    };
}

+ (NSValueTransformer *)paddingJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (![value isKindOfClass:[NSArray class]]
            || [value count] != 4) {
            return nil;
        }
        NSArray *paddingArr = (NSArray *)value;
        return [NSString stringWithFormat:@"{%@, %@, %@, %@}",
                paddingArr[0], paddingArr[1], paddingArr[2], paddingArr[3]];
    }];;
}

@end
