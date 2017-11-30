//
//  ScheduleDatePickerCell.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/13.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDatePickerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic, readonly) NSDate *date;
@end
