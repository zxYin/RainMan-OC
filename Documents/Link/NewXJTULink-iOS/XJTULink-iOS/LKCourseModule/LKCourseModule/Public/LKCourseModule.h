//
//  LKCourseModule.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
#import "YLTableView.h"
@interface LKCourseModule : NSObject

@end


@interface LKCourseService : LKService
- (RACSignal *)LKCourse_countdownSecondSignal:(NSDictionary *)params;
- (YLTableViewSection *)LKCourse_courseAdSection:(NSDictionary *)params;
- (YLTableViewSection *)LKCourse_scheduleSection:(NSDictionary *)params;
- (UIViewController *)LKCourse_transcriptsViewController:(NSDictionary *)params;
- (UIViewController *)LKCourse_teachingEvaluationViewController:(NSDictionary *)params;
- (UIViewController *)LKCourse_scheduleViewController:(NSDictionary *)params;
@end
