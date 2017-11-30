//
//  CourseTableAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseTableAPIManager.h"
#import <Mantle/Mantle.h>
@implementation CourseTableAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"stuInfo/getStuCurriculumTable/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (BOOL)isResponseDataCorrect:(YLResponseModel *)reponseModel {
    BOOL result = [super beforePerformSuccessWithResponseModel:reponseModel];
    NSArray *dayList = [super fetchData][@"data"][@"courseList"];
    return result && (dayList.count != 0);
}

- (id)fetchDataFromModel:(Class)clazz {
    NSError *error = nil;
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:7];
    NSArray *dayList = [super fetchData][@"data"][@"courseList"];
    if (dayList.count >=7) {
        for (NSArray *list in dayList) {
            NSArray *courses = [MTLJSONAdapter modelsOfClass:clazz fromJSONArray:list error:&error];
            courses = [courses sortedArrayUsingComparator:^NSComparisonResult(id term1, id term2) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([term1 respondsToSelector:@selector(time)]
                    && [term2 respondsToSelector:@selector(time)]
                    ) {
                    return [[term1 performSelector:@selector(time)] compare:
                            [term2 performSelector:@selector(time)]];
                }
#pragma clang diagnostic pop
                return YES;
            }];
            if (error == nil) {
                [result addObject:courses];
            } else {
                NSLog(@"error:%@",error);
            }
        }
    }

    return [result copy];
}

@end
