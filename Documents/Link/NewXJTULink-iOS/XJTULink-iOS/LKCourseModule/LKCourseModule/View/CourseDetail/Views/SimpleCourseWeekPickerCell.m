//
//  SimpleCourseWeekPickerCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SimpleCourseWeekPickerCell.h"

@interface SimpleCourseWeekPickerCell()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, copy) NSArray *weeks;
@end

@implementation SimpleCourseWeekPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kCourseWeekPickerComponetType) {
        return 3;
    } else {
        return 20;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    if (component == kCourseWeekPickerComponetType) {
        titleLabel.text = self.types[row];
    } else {
        titleLabel.text = self.weeks[row];
    }
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case kCourseWeekPickerComponetType:
            self.type = row;
            break;
        case kCourseWeekPickerComponetStart:
            self.start = row+1;
            break;
        case kCourseWeekPickerComponetEnd:
            self.end = row+1;
            break;
        default:
            break;
    }
}

- (NSArray *)types {
    if(_types == nil) {
        _types = @[@"全部", @"单周", @"双周"];
    }
    return _types;
}



- (NSArray *)weeks {
    if (_weeks == nil) {
        NSMutableArray *muWeeks = [NSMutableArray arrayWithCapacity:11];
        for (NSInteger i=1; i<=20; i++) {
            [muWeeks addObject:[NSString stringWithFormat:@"%td",i]];
        }
        _weeks = [muWeeks copy];
    }
    return _weeks;
}

@end
