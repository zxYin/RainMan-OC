//
//  ScheduleEditViewModel.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "ScheduleModel.h"

extern NSString * const kNetworkingRACTypeScheduleAdd;
extern NSString * const kNetworkingRACTypeScheduleDelete;
extern NSString * const kNetworkingRACTypeScheduleUpdate;

typedef NS_ENUM(NSUInteger, ScheduleEditViewModelType) {
    ScheduleEditViewModelTypeAdd,
    ScheduleEditViewModelTypeUpdate
};

@interface ScheduleEditViewModel : NSObject<YLNetworkingRACProtocol>
@property (strong, nonatomic) ScheduleModel *scheduleModel;
@property (assign, nonatomic, readonly) BOOL isValid;
@property (nonatomic, assign) ScheduleEditViewModelType type;

- (instancetype)initWithType:(ScheduleEditViewModelType)type;
@end
