//
//  ScheduleEditViewController.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScheduleEditViewModel;

@interface ScheduleEditViewController : UIViewController
- (instancetype)initWithViewModel:(ScheduleEditViewModel *)viewModel;
@end
