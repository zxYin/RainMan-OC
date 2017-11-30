//
//  AppMediator+LKCourseModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "LKService.h"
#import "YLTableView.h"

@interface AppMediator (LKCourseModule)


/**
 倒计时的信号量
 绝对值代表剩余时间
 正值代表上课时间
 负值代表下课时间
 
 如果是NSIntegerMax则代表已经无课了
 
 @return
 */
- (RACSignal *)LKCourse_countdownSecondSignal;

- (YLTableViewSection *)LKCourse_courseAdSection;
- (YLTableViewSection *)LKCourse_scheduleSection;
- (void)LKCourse_transcriptsViewController:(void(^)(UIViewController *transcriptsViewController))block;
- (void)LKCourse_teachingEvaluationViewController:(void(^)(UIViewController *teachingEvaluationViewController))block;
- (void)LKCourse_scheduleViewController:(void(^)(UIViewController *scheduleViewController))block;
@end
