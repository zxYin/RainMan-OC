//
//  CourseTimePickerCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat const CourseTimePickerCellHeight = 93;
extern NSString * const CourseTimePickerCellIdentifier;
@interface CourseTimePickerCell : UITableViewCell
@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger end;

@end
