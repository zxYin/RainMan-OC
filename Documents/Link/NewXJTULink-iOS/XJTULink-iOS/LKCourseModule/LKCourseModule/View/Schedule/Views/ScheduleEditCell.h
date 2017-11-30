//
//  ScheduleEditCellTableViewCell.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/13.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScheduleEditCellType) {
    kScheduleEditCellName = 0,
    kScheduleEditCellTime,
    kScheduleEditCellLocale,
    kScheduleEditDeleteCell,
};

@interface ScheduleEditCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textFieldView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end
