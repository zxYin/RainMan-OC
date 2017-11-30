//
//  LKUserModel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKUserModel.h"

@implementation LKUserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId":@"user_id",
             @"name":@"name",
             @"nickname":@"nickname",
             @"avatarURL":@"avatar",
             @"tag":@"tag",
             };
}
@end
