//
//  CourseCountdownViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseCountdownViewModel.h"
#import "AppMediator+LKCourseModule.h"

@implementation CourseCountdownViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasNext = YES;
        RACSignal *countdownSignal = [[AppMediator sharedInstance] LKCourse_countdownSecondSignal];
        
        @weakify(self);
        [[countdownSignal deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id value) {
            @strongify(self);
            NSInteger amountSeconds = [value integerValue];
             if (amountSeconds == NSIntegerMax) {
                 self.hasNext = NO;
                 return;
             }
             
            self.isClassTime = amountSeconds > 0;
            amountSeconds = labs(amountSeconds);
            
            NSInteger hours = amountSeconds / (60 * 60);
            amountSeconds %= 60 * 60;
            NSInteger minutes = amountSeconds / 60;
            amountSeconds %= 60;
            NSInteger seconds = amountSeconds;
            
            if (hours == 0) {
                self.time = [NSString stringWithFormat:@"%02td:%02td", minutes, seconds];
                self.second = nil;
            } else {
                self.time =  [NSString stringWithFormat:@"%02td:%02td", hours, minutes];
                self.second = [NSString stringWithFormat:@"%02td", seconds];
            }
             
            if (self.isClassTime) {
                self.leftText = @"嘘！还有";
                self.rightText = @"下课";
            } else {
                self.leftText = @"诶！还有";
                self.rightText = @"上课";
            }
        }];
        
    }
    return self;
}
@end
