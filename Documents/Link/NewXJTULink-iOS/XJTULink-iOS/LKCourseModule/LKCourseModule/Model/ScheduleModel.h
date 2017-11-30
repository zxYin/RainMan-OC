//
//  ScheduleModel.h
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ScheduleModel : MTLModel<MTLJSONSerializing, NSCopying>
@property (assign, nonatomic) NSInteger eventId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *locale;

@property (assign, nonatomic) NSTimeInterval timestamp;
@end
