//
//  CourseDetailCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const CourseDetailCellIdentifier;
#define CourseDetailCellHeight 44
@interface CourseDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
