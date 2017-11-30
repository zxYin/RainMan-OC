//
//  ScheduleItemViewModel.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleModel.h"
#import "LKNetworking.h"

@interface ScheduleItemViewModel : NSObject<YLNetworkingRACProtocol>
@property (assign, nonatomic) NSInteger eventId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *locale;
@property (assign, nonatomic, readonly) NSInteger leftDay;
@property (assign, nonatomic, readonly) BOOL isEnd;

- (instancetype)initWithModel:(ScheduleModel *)model;
- (void)deleteLocalArchive;
@end
