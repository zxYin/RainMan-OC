//
//  CourseDetailHeaderView.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSInteger const CourseDetailHeaderViewHeight = 222;
@interface CourseDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)headerView;
@end
