//
//  CourseManager.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "CourseViewModel.h"
#import "LKNetworking.h"


@interface CourseManager : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

// 完整课表
@property (nonatomic, copy) NSArray<NSArray<CourseModel *> *> *courseTable;
@property (nonatomic, copy, readonly) NSArray<CourseModel *> *courseList;

+ (CourseManager *)sharedInstance;

- (BOOL)isConflict:(CourseModel *)courseModel;
- (BOOL)addCourseModel:(CourseModel *)courseModel;

- (void)removeCourseWithUUID:(NSString *)uuid;
@end
