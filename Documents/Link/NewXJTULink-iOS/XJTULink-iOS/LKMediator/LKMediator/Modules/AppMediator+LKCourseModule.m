//
//  AppMediator+LKCourseModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKCourseModule.h"
NSString * const kAppMediatorCourseModule= @"LKCourseModule";

NSString * const kAppMediatorCourseServiceCountdownSecondSignal = @"countdownSecondSignal";
NSString * const kAppMediatorCourseServiceTranscriptsViewController = @"transcriptsViewController";
NSString * const kAppMediatorCourseServiceCourseAdSection = @"courseAdSection";
NSString * const kAppMediatorCourseServiceScheduleSection = @"scheduleSection";
NSString * const kAppMediatorCourseServiceTeachingEvaluationViewController = @"teachingEvaluationViewController";
NSString * const kAppMediatorCourseServiceScheduleViewController = @"scheduleViewController";

@implementation AppMediator (LKCourseModule)

+ (void)load {
    LKModule(@"course"    , kAppMediatorCourseModule);
    LKRoute(@"/schedule/", kAppMediatorCourseServiceScheduleViewController , kAppMediatorCourseModule);
    
}

- (RACSignal *)LKCourse_countdownSecondSignal {
    return [[self performAction:kAppMediatorCourseServiceCountdownSecondSignal
                       onModule:kAppMediatorCourseModule
                         params:nil]
            safeType:[RACSignal class]];
}

- (void)LKCourse_transcriptsViewController:(void(^)(UIViewController *transcriptsViewController))block {
    if (block) {
        [[self performAction:kAppMediatorCourseServiceTranscriptsViewController
                    onModule:kAppMediatorCourseModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
}

- (void)LKCourse_teachingEvaluationViewController:(void(^)(UIViewController *teachingEvaluationViewController))block {
    if (block) {
        [[self performAction:kAppMediatorCourseServiceTeachingEvaluationViewController
                    onModule:kAppMediatorCourseModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
    
}

- (void)LKCourse_scheduleViewController:(void(^)(UIViewController *scheduleViewController))block {
    if (block) {
        [[self performAction:kAppMediatorCourseServiceScheduleViewController
                    onModule:kAppMediatorCourseModule
                      params:@{kAppMediatorFinishUsingBlock:[block copy]}]
         safeType:[UIViewController class]];
    }
    
}

- (YLTableViewSection *)LKCourse_courseAdSection {
    return [[self performAction:kAppMediatorCourseServiceCourseAdSection
                       onModule:kAppMediatorCourseModule
                         params:nil]
            safeType:[YLTableViewSection class]];
}

- (YLTableViewSection *)LKCourse_scheduleSection {
    return [[self performAction:kAppMediatorCourseServiceScheduleSection
                       onModule:kAppMediatorCourseModule
                         params:nil]
            safeType:[YLTableViewSection class]];
}
@end
