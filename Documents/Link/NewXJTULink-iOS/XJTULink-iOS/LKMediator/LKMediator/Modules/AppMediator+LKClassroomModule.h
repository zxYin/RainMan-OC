//
//  AppMediator+LKClassroomModule.h
//  LKMediator
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"

@interface AppMediator (LKClassroomModule)
- (UIViewController *)LKClassroom_webClassroomViewController;
- (UIViewController *)LKClassroom_classroomViewController;
@end
