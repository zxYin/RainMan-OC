//
//  EvaluationCourseModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "EvaluationCourseModel.h"

@implementation EvaluationCourseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"course_name",
             @"isEvluted":@"status",
             @"code":@"course_num",
             @"teacher":@"teacher",
             @"college":@"college",
             @"type":@"type",
             @"count":@"count",
             };
}
@end
