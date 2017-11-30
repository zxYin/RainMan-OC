//
//  CourseDetailViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseDetailViewModel.h"
#import "Foundation+LKCourse.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@import UIKit.UIImage;

NSString * const kCourseDetailItemKeyIcon = @"kCourseDetailItemKeyIcon";
NSString * const kCourseDetailItemKeyText = @"kCourseDetailItemKeyText";
@implementation CourseDetailViewModel
- (instancetype)initWithCourseViewModel:(CourseViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.courseViewModel = viewModel;
        self.scheduleItemViewModel = viewModel.scheduleItemViewModel;
        
        CourseModel *model = viewModel.model;
        RAC(self, title) = RACObserve(model, name);
        @weakify(self);
        [[RACSignal merge:@[
                            RACObserve(model, locale),
                            RACObserve(model, teachers),
                            RACObserve(model, timeRange),
                            RACObserve(model, weekFormatter),
                            ]] subscribeNext:^(id x) {
            @strongify(self);
            
            NSMutableArray *items = [NSMutableArray array];
            
            [items addObject:@{
                               kCourseDetailItemKeyIcon: [UIImage imageNamed:@"course_locale_icon_normal"],
                               kCourseDetailItemKeyText: model.locale?:@""
                               }];
            
            [model.teachers enumerateObjectsUsingBlock:^(NSString *teacher, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *item;
                if (idx == 0) {
                    item = @{
                             kCourseDetailItemKeyIcon: [UIImage imageNamed:@"course_teacher_icon_normal"],
                             kCourseDetailItemKeyText: teacher
                              };
                } else {
                    item = @{
                             kCourseDetailItemKeyText: teacher
                             };
                }
                [items addObject:item];
            }];
        
            
            [items addObject:@{
                               kCourseDetailItemKeyIcon: [UIImage imageNamed:@"course_time_icon_normal"],
                               kCourseDetailItemKeyText: [NSString stringWithFormat:@"%@ %@节",[NSString stringForWeekday:model.weekday], LKTimeFromRange(model.timeRange)]
                               }];
            
            [items addObject:@{
                               kCourseDetailItemKeyIcon: [UIImage imageNamed:@"course_week_icon_normal"],
                               kCourseDetailItemKeyText: [NSString stringWithFormat:@"%@周",model.weekFormatter.groupedString]
                               }];
            
            
            self.items = [items copy];
        }];
        
    }
    return self;
}
@end
