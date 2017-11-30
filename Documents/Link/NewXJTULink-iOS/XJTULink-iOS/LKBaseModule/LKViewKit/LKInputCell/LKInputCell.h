//
//  CourseEditCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const LKInputCellIdentifier;
@interface LKInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;


@end
