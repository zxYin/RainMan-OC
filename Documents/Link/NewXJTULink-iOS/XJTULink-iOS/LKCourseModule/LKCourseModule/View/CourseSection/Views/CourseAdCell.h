//
//  CourseAdCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseAdViewModel.h"
#import "YLTableView.h"

#define CourseAdCellHeight 110
@interface CourseAdCell : UITableViewCell<YLTableViewCellProtocol>
@property (nonatomic, strong) CourseAdViewModel *viewModel;

@end
