//
//  IndexNewsViewCell.h
//  XJTUIn
//
//  Created by 李云鹏 on 15/5/6.
//  Copyright (c) 2015年 李云鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTableView.h"
#import "NewsItemViewModel.h"
#import "MGSwipeTableCell.h"
#define NewsViewCellHeight 28
extern NSString *const NewsViewCellIdentifier;
@interface NewsViewCell : MGSwipeTableCell<YLTableViewCellProtocol>
@property (nonatomic, strong) NewsItemViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end
