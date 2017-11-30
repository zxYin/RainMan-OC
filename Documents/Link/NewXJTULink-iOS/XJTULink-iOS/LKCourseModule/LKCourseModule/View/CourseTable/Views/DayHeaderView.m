//
//  HeaderView.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import "DayHeaderView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


NSString *const DayHeaderViewIdentifier = @"DayHeaderView";

@interface DayHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *selectedTagLabel;

@end
@implementation DayHeaderView

- (void)layoutSubviews {
    if (_selected) {
        _selectedTagLabel.hidden = NO;
        _dayLabel.textColor = UIColorFromRGB(0xF5A623);
        _weekdayLabel.textColor = UIColorFromRGB(0xF5A623);//6F7179
    } else {
        _selectedTagLabel.hidden = YES;
        _dayLabel.textColor = UIColorFromRGB(0x6F7179);
        _weekdayLabel.textColor = UIColorFromRGB(0x6F7179);
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}
@end
