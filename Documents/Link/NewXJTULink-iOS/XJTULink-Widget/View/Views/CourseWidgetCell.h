//
//  CourseWidgetCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/11/11.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const CourseWidgetCellIdentifier;
#define CourseWidgetCellHeight 60
@interface CourseWidgetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;

@end
