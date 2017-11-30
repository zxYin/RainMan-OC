//
//  ActivityModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"introduction":@"introduction",
             @"imageURL":@"image",
             @"name":@"name",
             @"honor":@"title",
             };
}
@end
