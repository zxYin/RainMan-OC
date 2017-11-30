//
//  LKClassroomModule.m
//  LKClassroomModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKClassroomModule.h"
#import "WebClassroomViewController.h"
@implementation LKClassroomModule

@end

@implementation LKClassroomService
- (UIViewController *)LKClassroom_webClassroomViewController:(NSDictionary *)params {
    NSLog(@"[LKClassroomService] webClassroomViewController");
    return [[WebClassroomViewController alloc] init];
}

- (UIViewController *)LKClassroom_classroomViewController:(NSDictionary *)params {
    NSLog(@"[LKClassroomService] classroomViewController");
    return [[WebClassroomViewController alloc] init];
}
@end
