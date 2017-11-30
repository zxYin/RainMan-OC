//
//  LibBookItemCell.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTableView.h"
#import "LibBookViewModel.h"
#define LibBookItemCellHeight 64

@interface LibBookItemCell : UITableViewCell<YLTableViewCellProtocol>
@property (nonatomic, strong) LibBookViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@end
