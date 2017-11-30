//
//  TeachingEvaluationViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TeachingEvaluationViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TeachingEvaluationAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
#import <Mantle/Mantle.h>
@interface TeachingEvaluationViewModel()
@property (nonatomic, strong) TeachingEvaluationAPIManager *teachingEvaluationAPIManager;
@end
@implementation TeachingEvaluationViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *result = [self.teachingEvaluationAPIManager fetchData];
        self.notice = [result stringForKey:kTeachingEvaluationAPIManagerResultKeyNotice];
        self.targets = result[kTeachingEvaluationAPIManagerResultKeyTargets];
        self.courseViewModels =
        [MTLJSONAdapter modelsOfClass:[EvaluationCourseViewModel class]
                        fromJSONArray:result[kTeachingEvaluationAPIManagerResultKeyCourses]
                                error:NULL];
    }];
    
    
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.teachingEvaluationAPIManager;
}

- (TeachingEvaluationAPIManager *)teachingEvaluationAPIManager {
    if (_teachingEvaluationAPIManager == nil) {
        _teachingEvaluationAPIManager = [TeachingEvaluationAPIManager apiManagerByType:TeachingEvaluationAPIManagerTypeGet];
    }
    return _teachingEvaluationAPIManager;
}
@end


