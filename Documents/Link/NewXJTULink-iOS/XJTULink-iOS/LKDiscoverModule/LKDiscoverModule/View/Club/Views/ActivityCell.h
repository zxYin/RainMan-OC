//
//  ActivityCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
#define ActivityCellHeight ((CGRectGetWidth([UIScreen mainScreen].bounds) * 9 / 16) + 42)

//254
#define ActivityCellIdentifier @"ActivityCell"
@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *honorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (nonatomic, strong) ActivityModel *viewModel;
@end
