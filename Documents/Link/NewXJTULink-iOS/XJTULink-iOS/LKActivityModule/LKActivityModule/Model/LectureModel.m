//
//  LectureModel.m
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureModel.h"

@implementation LectureModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"lecture_title",
             @"time":@"lecture_date",
             @"locale":@"lecture_address",
             @"url":@"lecture_url",
             };
}
@end
