//
//  TeachingEvaluationAPIManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TeachingEvaluationAPIManager.h"

NSString * const kTeachingEvaluationAPIManagerResultKeyNotice = @"notification";
NSString * const kTeachingEvaluationAPIManagerResultKeyTargets = @"targets";
NSString * const kTeachingEvaluationAPIManagerResultKeyCourses = @"teacher_evluations";



NSString * const kTeachingEvaluationAPIManagerParamsKeyCode = @"kTeachingEvaluationAPIManagerParamsKeyCode";
NSString * const kTeachingEvaluationAPIManagerParamsKeyScores = @"kTeachingEvaluationAPIManagerParamsKeyScores";
NSString * const kTeachingEvaluationAPIManagerParamsKeyComment = @"kTeachingEvaluationAPIManagerParamsKeyComment";
NSString * const kTeachingEvaluationAPIManagerParamsKeyGeneralComment = @"kTeachingEvaluationAPIManagerParamsKeyGeneralComment";

@interface TeachingEvaluationSubmitAPIManager : TeachingEvaluationAPIManager
@end

@implementation TeachingEvaluationSubmitAPIManager

- (NSString *)path {
    return @"stuInfo/postTeacherEvaluation/";
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

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"course_num"] = params[kTeachingEvaluationAPIManagerParamsKeyCode];
    resultParams[@"score"] = params[kTeachingEvaluationAPIManagerParamsKeyScores];
    resultParams[@"comment"] = params[kTeachingEvaluationAPIManagerParamsKeyComment];
    resultParams[@"general_comment"] = params[kTeachingEvaluationAPIManagerParamsKeyGeneralComment];
    return resultParams;
}

@end


@implementation TeachingEvaluationAPIManager

- (NSString *)path {
    return @"stuInfo/getTeacherEvaluations/";
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

- (id)fetchData {
    return [super fetchData][@"data"];
}

+ (instancetype)apiManagerByType:(TeachingEvaluationAPIManagerType)type {
    switch (type) {
        case TeachingEvaluationAPIManagerTypeGet:
            return [[TeachingEvaluationAPIManager alloc] init];
            break;
        case TeachingEvaluationAPIManagerTypeSubmit:
            return [[TeachingEvaluationSubmitAPIManager alloc] init];
        default:
            break;
    }
}

@end
