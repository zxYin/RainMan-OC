//
//  LKClassroomModule.h
//  LKClassroomModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <LKBaseModule/LKService.h>

@interface LKClassroomModule : NSObject

@end

@interface LKClassroomService : LKService
- (UIViewController *)LKClassroom_webClassroomViewController:(NSDictionary *)params;
- (UIViewController *)LKClassroom_classroomViewController:(NSDictionary *)params;
@end
