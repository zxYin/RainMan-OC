//
//  AppMediator+LKClassroomModule.m
//  LKMediator
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKClassroomModule.h"
NSString * const kAppMediatorClassroomModule = @"LKClassroomModule";
NSString * const kAppMediatorClassroomServiceWebClassroomViewController = @"webClassroomViewController";
NSString * const kAppMediatorClassroomServiceClassroomViewController = @"classroomViewController";

@implementation AppMediator (LKClassroomModule)
+ (void)load {
    LKModule(@"classroom"    , kAppMediatorClassroomModule);
    LKRoute(@"/"        , kAppMediatorClassroomServiceWebClassroomViewController     , kAppMediatorClassroomModule);
    
}

- (UIViewController *)LKClassroom_webClassroomViewController {
    return [[self performAction:kAppMediatorClassroomServiceWebClassroomViewController
                       onModule:kAppMediatorClassroomModule
                         params:nil]
            safeType:[UIViewController class]];
}

- (UIViewController *)LKClassroom_classroomViewController {
    return [[self performAction:kAppMediatorClassroomServiceClassroomViewController
                       onModule:kAppMediatorClassroomModule
                         params:nil]
            safeType:[UIViewController class]];
}
@end
