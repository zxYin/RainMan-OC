//
//  ClubItemCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubViewModel.h"
#define ClubItemCellHeight 180
#define ClubItemCellIdentifier @"ClubItemCell"

@class ClubItemCell;
@protocol ClubItemCellDelegate <NSObject>
- (void)clubItemCell:(ClubItemCell *)cell shareButtonDidClick:(id)sender;
@end


@interface ClubItemCell : UITableViewCell
@property (nonatomic, strong) ClubViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;

@property (weak, nonatomic) id<ClubItemCellDelegate> delegate;


@end
