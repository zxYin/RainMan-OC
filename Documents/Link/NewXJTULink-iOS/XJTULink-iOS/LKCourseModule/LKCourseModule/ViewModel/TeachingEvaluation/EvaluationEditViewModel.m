//
//  EvaluationEditViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "EvaluationEditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TeachingEvaluationAPIManager.h"
@interface EvaluationEditViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSArray *targets;
@property (nonatomic, strong) NSMutableArray *mutableScores;
@property (nonatomic, strong) TeachingEvaluationAPIManager *teachingEvaluationAPIManager;
@end

@implementation EvaluationEditViewModel
- (instancetype)initWithTargets:(NSArray *)targets {
    self = [super init];
    if (self) {
        self.targets = targets;
        self.scores = [self.mutableScores copy];
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    RACSignal *generalCommentValid = [RACObserve(self, generalComment) map:^id(id value) {
        return @([value length] > 0);
    }];
    
    RACSignal *commentValid = [RACObserve(self, comment) map:^id(id value) {
        return @([value length] > 0);
    }];
    
    RACSignal *scoresValid = [RACObserve(self, scores) map:^id(NSArray *scores) {
        __block NSInteger sum = 0;
        [scores enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += [obj integerValue];
        }];
        NSLog(@"sum = %td", sum);
        return @(sum != scores.count * 5);
    }];
    
    RAC(self, isValid) =
    [RACSignal combineLatest:@[generalCommentValid, commentValid, scoresValid]
                      reduce:^id(NSNumber*generalCommentValid, NSNumber *commentValid,NSNumber *scoresValid){
                          return @([generalCommentValid boolValue]
                                    && [commentValid boolValue]
                                    && [scoresValid boolValue]);
                      }];
}

- (void)setScore:(NSInteger)score forIndex:(NSInteger)index {
    self.mutableScores[index] = @(score);
    self.scores = [self.mutableScores copy];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.teachingEvaluationAPIManager;
}


- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kTeachingEvaluationAPIManagerParamsKeyCode] = self.courseViewModel.code;
    params[kTeachingEvaluationAPIManagerParamsKeyScores] = self.scores;
    params[kTeachingEvaluationAPIManagerParamsKeyComment] = self.comment;
    params[kTeachingEvaluationAPIManagerParamsKeyGeneralComment] = self.generalComment;
    return params;
}

- (NSMutableArray *)mutableScores {
    if(_mutableScores == nil) {
        _mutableScores = [[NSMutableArray alloc] initWithCapacity:self.targets.count];
        for (NSInteger i=0; i<self.targets.count; i++) {
            _mutableScores[i] = @(5);
        }
    }
    return _mutableScores;
}

- (TeachingEvaluationAPIManager *)teachingEvaluationAPIManager {
    if (_teachingEvaluationAPIManager == nil) {
        _teachingEvaluationAPIManager = [TeachingEvaluationAPIManager apiManagerByType:TeachingEvaluationAPIManagerTypeSubmit];
        _teachingEvaluationAPIManager.dataSource = self;
    }
    return _teachingEvaluationAPIManager;
}
@end
