//
//  SimpleCourseWeekPickerCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekFormatter.h"
static CGFloat const SimpleCourseWeekPickerCellHeight = 93;

typedef NS_ENUM(NSInteger, CourseWeekPickerComponet) {
    kCourseWeekPickerComponetType = 0,
    kCourseWeekPickerComponetStart,
    kCourseWeekPickerComponetEnd,
};


@interface SimpleCourseWeekPickerCell : UITableViewCell
@property (nonatomic, assign) WeekType type;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger end;
@end
