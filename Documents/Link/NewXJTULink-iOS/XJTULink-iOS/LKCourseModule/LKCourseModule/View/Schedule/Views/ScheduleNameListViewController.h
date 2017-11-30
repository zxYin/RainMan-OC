//
//  ScheduleNameListViewController.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/14.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"
@class ScheduleNameListViewController;

@protocol ScheduleNameListViewControllerDelegate <NSObject>
@required
- (void)scheduleNameListViewController:(ScheduleNameListViewController *)viewController didSelectAtCourseName:(NSString *)name;
@end

@interface ScheduleNameListViewController: UIViewController
@property (nonatomic, weak) id<ScheduleNameListViewControllerDelegate> delegate;
@end
