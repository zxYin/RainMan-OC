//
//  CourseViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "ScheduleItemViewModel.h"

@interface CourseViewModel : NSObject
@property (nonatomic, copy, readonly) CourseModel *model;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *locale;
@property (nonatomic, copy, readonly) NSString *rawTime;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *week;
@property (nonatomic, copy, readonly) NSString *weekday;
@property (nonatomic, copy, readonly) NSString *teacher;


@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger dayIndex;
@property (nonatomic, assign, readonly) NSInteger startIndex;
@property (nonatomic, assign, readonly) NSInteger length;
- (instancetype)initWithModel:(CourseModel *)model;
@end


@interface CourseViewModel (Schedule)
@property (nonatomic, strong, readonly) ScheduleItemViewModel *scheduleItemViewModel;
@end
