//
//  DepartmentModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DepartmentModel.h"

@implementation DepartmentModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"name",
             @"imageURL":@"image",
             @"introduction":@"introduction",
             };
}
@end
