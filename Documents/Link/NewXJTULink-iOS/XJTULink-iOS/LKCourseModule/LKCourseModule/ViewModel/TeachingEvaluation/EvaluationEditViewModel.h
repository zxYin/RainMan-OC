//
//  EvaluationEditViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "EvaluationCourseModel.h"
@interface EvaluationEditViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, strong) EvaluationCourseViewModel *courseViewModel;
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, copy, readonly) NSArray *targets;

@property (nonatomic, copy) NSString *generalComment;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSArray *scores;

- (instancetype)initWithTargets:(NSArray *)targets;
- (void)setScore:(NSInteger)score forIndex:(NSInteger)index;
@end
