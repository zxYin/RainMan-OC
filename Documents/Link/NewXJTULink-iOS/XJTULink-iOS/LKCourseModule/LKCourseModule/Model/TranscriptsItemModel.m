//
//  TranscriptsItemModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsItemModel.h"

@implementation TranscriptsItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"semester":@"semester",
             @"type":@"course_type",
             @"score":@"score",
             @"testNature":@"test_nature",
             @"code":@"course_code",
             @"name":@"course_name",
             @"nature":@"course_nature",
             @"schoolYear":@"school_year",
             @"credit":@"credit",
             @"isValid":@"is_valid",
             };
}
@end
