//
//  ScheduleEditCellTableViewCell.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/13.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleEditCell.h"
@interface ScheduleEditCell()<UITextFieldDelegate>

@end

@implementation ScheduleEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    
    self.textFieldView.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
