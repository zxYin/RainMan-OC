//
//  MTLValueTransformer+LKModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MTLValueTransformer+LKModel.h"
#import "Constants.h"
@implementation MTLValueTransformer (LKModel)
+ (instancetype)transformerOfPageShowType {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        PageShowType type = kPageShowTypeNative;
        if (![value isKindOfClass:[NSString class]]) {
            return @(type);
        }
        
        NSString *typeString = (NSString *)value;
        if ([[typeString lowercaseString] isEqualToString:@"web"]) {
            type = kPageShowTypeWeb;
        }
        return @(type);
    }];
}
@end
