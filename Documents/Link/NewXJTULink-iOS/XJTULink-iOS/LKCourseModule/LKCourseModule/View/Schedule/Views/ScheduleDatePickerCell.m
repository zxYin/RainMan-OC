//
//  ScheduleDatePickerCell.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/13.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleDatePickerCell.h"
#import <ReactiveCocoa.h>
@interface ScheduleDatePickerCell()
@property (strong, nonatomic) NSDate *date;
@end

@implementation ScheduleDatePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    RAC(self, date) = RACObserve(self.datePicker, date);
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dateChanged:(id)sender {
    UIDatePicker* control = (UIDatePicker *)sender;
    self.date = control.date;
}

@end
