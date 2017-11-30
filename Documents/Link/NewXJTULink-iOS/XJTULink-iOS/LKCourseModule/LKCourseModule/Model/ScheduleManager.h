//
//  ScheduleManager.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/12.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "ScheduleModel.h"

@interface ScheduleManager : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSArray<ScheduleModel *> *scheduleModels;

+ (instancetype)sharedInstance;
- (void)addScheduleModel:(ScheduleModel *)scheduleModel;
- (void)deleteScheduleModelWithEventId:(NSInteger)eventId;
- (void)updateScheduleModel:(ScheduleModel *)scheduleModel;

- (ScheduleModel *)fetchScheduleModelForKey:(NSString *)key;
@end
