//
//  ScheduleAPIManager.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"
extern NSString * const kScheduleAPIManagerResultKeyEventList;

extern NSString * const kScheduleAPIManagerParamsKeyName;
extern NSString * const kScheduleAPIManagerParamsKeyTime;
extern NSString * const kScheduleAPIManagerParamsKeyLocale;
extern NSString * const kScheduleAPIManagerParamsKeyId;

typedef NS_ENUM(NSUInteger, ScheduleAPIManagerType) {
    ScheduleAPIManagerTypeAdd,
    ScheduleAPIManagerTypeDelete,
    ScheduleAPIManagerTypeGet,
    ScheduleAPIManagerTypeUpdate,
};

@interface ScheduleAPIManager : YLBaseAPIManager<YLAPIManager>
+ (instancetype)apiManagerByType:(ScheduleAPIManagerType)type;
@end
