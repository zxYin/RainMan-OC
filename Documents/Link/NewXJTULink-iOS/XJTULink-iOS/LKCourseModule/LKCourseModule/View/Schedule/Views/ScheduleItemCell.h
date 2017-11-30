//
//  ScheduleItemCell.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItemViewModel.h"
#import "YLTableView.h"
#define ScheduleItemCellHeight 90

@interface ScheduleItemCell : UITableViewCell<YLTableViewCellProtocol>
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *localeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftDayLabel;
@property (strong, nonatomic) IBOutlet UIView *dayInfoView;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, assign) NSString *title;
@property (strong, nonatomic) ScheduleItemViewModel *viewModel;
@end
