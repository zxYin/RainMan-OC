//
//  ScheduleListViewModel.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "ScheduleItemViewModel.h"

@interface ScheduleListViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy) NSArray<ScheduleItemViewModel *> *scheduleItemViewModels;
@end
