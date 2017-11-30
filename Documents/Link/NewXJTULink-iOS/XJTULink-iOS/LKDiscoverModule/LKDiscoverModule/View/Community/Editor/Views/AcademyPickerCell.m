//
//  AcademyPickerCell.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/4.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "AcademyPickerCell.h"
#import "AcademyManager.h"
@interface AcademyPickerCell()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *academyPickerView;

@end

@implementation AcademyPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.academies = [AcademyManager sharedInstance].academyList;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    NSInteger row = [self.academies indexOfObject:self.selectedAcademy];
    if (row == NSNotFound) {
        row = 0;
    }
    [self.academyPickerView selectRow:row inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.academies.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.academies[row];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedAcademy = self.academies[row];
}

@end
