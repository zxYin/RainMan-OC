//
//  CourseCountdownView.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCountdownViewModel.h"
#define CourseCountdownViewHeight 60
@interface CourseCountdownView : UIView
@property (nonatomic, strong) CourseCountdownViewModel *viewModel;
+ (instancetype)courseCountdownView;
@end
