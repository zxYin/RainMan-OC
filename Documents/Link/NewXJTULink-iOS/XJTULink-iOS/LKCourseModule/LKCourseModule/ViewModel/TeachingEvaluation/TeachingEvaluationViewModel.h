//
//  TeachingEvaluationViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "EvaluationCourseModel.h"
@interface TeachingEvaluationViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSDictionary *targets;
@property (nonatomic, copy) NSArray<EvaluationCourseViewModel *> *courseViewModels;
@end
