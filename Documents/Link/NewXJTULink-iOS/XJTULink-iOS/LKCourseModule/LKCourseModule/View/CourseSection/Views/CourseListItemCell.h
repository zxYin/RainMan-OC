//
//  CourseListItemCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2017/4/18.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTableView.h"
#import "CourseViewModel.h"
#define CourseListItemCellHeight 40
@interface CourseListItemCell : UITableViewCell<YLTableViewCellProtocol>
@property (nonatomic, strong) CourseViewModel *viewModel;
@property (nonatomic, strong) UIColor *tintColor;
@end
