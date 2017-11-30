//
//  Foundation+LKCourse.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
@interface NSString (LKCourse)
- (NSInteger)weekdayValue;
+ (NSString *)stringForWeekday:(NSInteger)weekday;
@end



@interface NSArray (LKCourse)
- (NSUInteger)countWithTwoDimension;

// 获取课程列表所有的时间节点，每个节点都是计算从0点至时间点的秒数
- (NSArray *)intervalListOfCourses;
@end




@interface NSIndexSet (LKCourse)
- (NSArray *)lk_allIndexes;
@end
