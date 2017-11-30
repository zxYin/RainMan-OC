//
//  LectureItemCell.h
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTableView.h"
#import "LectureItemViewModel.h"
static NSInteger const LectureViewCellHeight = 84;
extern NSString * const LectureItemCellIdentifier;
@interface LectureItemCell : UITableViewCell<YLTableViewCellProtocol>
@property (nonatomic, strong) LectureItemViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
