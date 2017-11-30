//
//  TeachingEvaluationAPIManager.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNetworking.h"


extern NSString * const kTeachingEvaluationAPIManagerResultKeyNotice;
extern NSString * const kTeachingEvaluationAPIManagerResultKeyTargets;
extern NSString * const kTeachingEvaluationAPIManagerResultKeyCourses;


extern NSString * const kTeachingEvaluationAPIManagerParamsKeyCode;
extern NSString * const kTeachingEvaluationAPIManagerParamsKeyScores;
extern NSString * const kTeachingEvaluationAPIManagerParamsKeyComment;
extern NSString * const kTeachingEvaluationAPIManagerParamsKeyGeneralComment;

typedef NS_ENUM(NSInteger, TeachingEvaluationAPIManagerType) {
    TeachingEvaluationAPIManagerTypeGet,
    TeachingEvaluationAPIManagerTypeSubmit,
};

@interface TeachingEvaluationAPIManager : YLBaseAPIManager<YLAPIManager>
+ (instancetype)apiManagerByType:(TeachingEvaluationAPIManagerType)type;
@end
