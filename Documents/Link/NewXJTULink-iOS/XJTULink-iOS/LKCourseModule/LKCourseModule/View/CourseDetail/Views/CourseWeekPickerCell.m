//
//  CourseWeekPickerCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseWeekPickerCell.h"

@implementation CourseWeekPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
