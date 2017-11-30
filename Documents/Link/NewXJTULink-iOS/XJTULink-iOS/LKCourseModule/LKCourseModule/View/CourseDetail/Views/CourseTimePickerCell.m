//
//  CourseTimePickerCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseTimePickerCell.h"
#import "ViewsConfig.h"
NSString * const CourseTimePickerCellIdentifier = @"CourseTimePickerCell";


typedef NS_ENUM(NSInteger, CourseTimePickerComponet) {
    kCourseTimePickerComponetWeekday = 0,
    kCourseTimePickerComponetStart,
    kCourseTimePickerComponetEnd,
};

@interface CourseTimePickerCell ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (nonatomic, copy) NSArray *weekdays;
@property (nonatomic, copy) NSArray *times;
@end

@implementation CourseTimePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.timePickerView.
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    
    
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"初始化:%td,%td,%td",self.weekday, self.start, self.end);
    [self.timePickerView selectRow:self.weekday inComponent:kCourseTimePickerComponetWeekday animated:NO];
    [self.timePickerView selectRow:MAX(self.start-1,0) inComponent:kCourseTimePickerComponetStart animated:NO];
    [self.timePickerView selectRow:MAX(self.end-1,0) inComponent:kCourseTimePickerComponetEnd animated:NO];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kCourseTimePickerComponetWeekday) {
        return 7;
    } else {
        return 11;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    if (component == kCourseTimePickerComponetWeekday) {
        titleLabel.text = self.weekdays[row];
    } else {
        titleLabel.text = self.times[row];
    }
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case kCourseTimePickerComponetWeekday:
            self.weekday = row;
            break;
        case kCourseTimePickerComponetStart:
            self.start = row+1;
            break;
        case kCourseTimePickerComponetEnd:
            self.end = row+1;
            break;
        default:
            break;
    }
}


- (NSArray *)weekdays {
    if (_weekdays == nil) {
        _weekdays = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    }
    return _weekdays;
}

- (NSArray *)times {
    if (_times == nil) {
        NSMutableArray *muTimes = [NSMutableArray arrayWithCapacity:11];
        for (NSInteger i=1; i<12; i++) {
            [muTimes addObject:[NSString stringWithFormat:@"%td",i]];
        }
        _times = [muTimes copy];
    }
    return _times;
}
@end
