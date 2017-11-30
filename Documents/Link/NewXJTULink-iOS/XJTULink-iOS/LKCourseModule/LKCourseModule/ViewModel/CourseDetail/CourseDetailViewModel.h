//
//  CourseDetailViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseViewModel.h"
#import "ScheduleItemViewModel.h"

extern NSString * const kCourseDetailItemKeyIcon;
extern NSString * const kCourseDetailItemKeyText;

@interface CourseDetailViewModel : NSObject
@property (nonatomic, strong) CourseViewModel *courseViewModel;
@property (nonatomic, strong) ScheduleItemViewModel *scheduleItemViewModel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *items;

- (instancetype)initWithCourseViewModel:(CourseViewModel *)viewModel;
@end
