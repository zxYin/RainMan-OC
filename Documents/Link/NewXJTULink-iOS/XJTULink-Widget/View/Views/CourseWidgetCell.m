//
//  CourseWidgetCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/11/11.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "CourseWidgetCell.h"
#import "UIImage+Tint.h"
NSString *const CourseWidgetCellIdentifier = @"CourseWidgetCellIdentifier";

@interface CourseWidgetCell()
@property (weak, nonatomic) IBOutlet UIView *timeBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *localeImageView;

@end
@implementation CourseWidgetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_timeLabel setTextColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
    [_timeBackgroundView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
    _timeBackgroundView.layer.cornerRadius = 2.0;
    _timeBackgroundView.clipsToBounds = YES;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        self.nameLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.localeLabel.textColor = [UIColor darkGrayColor];
//        self.timeLabel.textColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"widget_locale_logo"];
        self.localeImageView.image = [image imageWithTintColor:[UIColor blackColor]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
