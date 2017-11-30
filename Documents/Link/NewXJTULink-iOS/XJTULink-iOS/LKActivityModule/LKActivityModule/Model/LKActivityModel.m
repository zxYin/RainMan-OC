//
//  ActivityModel.m
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityModel.h"
#import "LectureModel.h"
@implementation LKActivityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}


+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"lecture_title"] != nil) {
        return LectureModel.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}


@end
