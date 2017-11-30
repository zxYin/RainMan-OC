//
//  CourseTableViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "CourseViewModel.h"
@interface CourseTableViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, assign, readonly) BOOL isCurrentWeek;

@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign, readonly) NSInteger originalWeek;
@property (nonatomic, copy) NSArray<CourseViewModel *> *courseViewModels;
@property (nonatomic, copy) NSArray *daysOfWeek;

- (instancetype)initWithWeek:(NSInteger)week;
- (void)resetWeek;
- (BOOL)isExpired:(CourseViewModel *)viewModel;

@end
