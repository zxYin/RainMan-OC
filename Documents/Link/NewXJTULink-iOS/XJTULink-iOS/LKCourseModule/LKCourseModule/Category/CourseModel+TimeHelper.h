//
//  CourseModel+TimeHelper.h
//  LKCourseModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "CourseModel.h"

@interface CourseModel (TimeHelper)

@property (nonatomic, assign, readonly) NSInteger startTimeIndex;
@property (nonatomic, assign, readonly) NSInteger endTimeIndex;



+ (NSString *)fetchTimeFromIndex:(NSInteger)index;

+ (NSInteger)fetchSecondsFromIndex:(NSInteger)index;

+ (BOOL)isStartOfClassAtIndex:(NSInteger)index;
@end
