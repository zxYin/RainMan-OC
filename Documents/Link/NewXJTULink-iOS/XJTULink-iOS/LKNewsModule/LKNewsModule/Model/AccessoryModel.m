//
//  AccessoryModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AccessoryModel.h"

@implementation AccessoryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"accessory_name",
             @"type":@"accessory_type",
             @"url":@"accessory_url",
             };
}
@end
