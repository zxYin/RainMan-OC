//
//  WeekCalendarLayout.h
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewModel.h"
@protocol WeekCourseTableLayoutDataSource<UICollectionViewDataSource>

- (CourseViewModel *)courseViewModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex
                                      maxDayIndex:(NSInteger)maxDayIndex
                                   minCourseIndex:(NSInteger)minCourseIndex
                                   maxCourseIndex:(NSInteger)maxCourseIndex;
@end


@interface WeekCourseTableLayout : UICollectionViewFlowLayout
@property (assign,nonatomic) NSInteger showDaysPerWeek;
@end
