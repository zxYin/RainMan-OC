//
//  ScheduleAPIManager.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleAPIManager.h"
#import <Mantle/Mantle.h>

NSString * const kScheduleAPIManagerResultKeyEventList = @"eventlist";

NSString * const kScheduleAPIManagerParamsKeyName = @"kScheduleAPIManagerParamsKeyName";
NSString * const kScheduleAPIManagerParamsKeyTime = @"kScheduleAPIManagerParamsKeyTime";
NSString * const kScheduleAPIManagerParamsKeyLocale = @"kScheduleAPIManagerParamsKeyLocale";
NSString * const kScheduleAPIManagerParamsKeyId = @"kScheduleAPIManagerParamsKeyId";

@interface ScheduleAddAPIManager : ScheduleAPIManager
@end

@implementation ScheduleAddAPIManager

- (NSString *)path {
    return @"stuInfo/event/addEvent/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"event_name"] = params[kScheduleAPIManagerParamsKeyName];
    resultParams[@"event_time"] = params[kScheduleAPIManagerParamsKeyTime];
    resultParams[@"event_locale"] = params[kScheduleAPIManagerParamsKeyLocale];
    return resultParams;
}
@end

@interface ScheduleDeleteAPIManager : ScheduleAPIManager
@end

@implementation ScheduleDeleteAPIManager

- (NSString *)path {
    return @"stuInfo/event/deleteEvent/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"event_id"] = params[kScheduleAPIManagerParamsKeyId];
    return resultParams;
}
@end

@interface ScheduleUpdateAPIManager : ScheduleAPIManager
@end

@implementation ScheduleUpdateAPIManager

- (NSString *)path {
    return @"stuInfo/event/updateEvent/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"event_id"] = params[kScheduleAPIManagerParamsKeyId];
    resultParams[@"event_name"] = params[kScheduleAPIManagerParamsKeyName];
    resultParams[@"event_time"] = params[kScheduleAPIManagerParamsKeyTime];
    resultParams[@"event_locale"] = params[kScheduleAPIManagerParamsKeyLocale];
    return resultParams;
}
@end

@implementation ScheduleAPIManager

- (NSString *)path {
    return @"stuInfo/event/getEvents/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return NO;
}

- (id)fetchDataFromModel:(Class)clazz {
    return [MTLJSONAdapter modelsOfClass:clazz
                           fromJSONArray:[super fetchData][@"data"][kScheduleAPIManagerResultKeyEventList]
                                   error:nil];
}

+ (instancetype)apiManagerByType:(ScheduleAPIManagerType)type {
    switch (type) {
        case ScheduleAPIManagerTypeAdd:
            return [[ScheduleAddAPIManager alloc] init];
            break;
        case ScheduleAPIManagerTypeDelete:
            return [[ScheduleDeleteAPIManager alloc] init];
            break;
        case ScheduleAPIManagerTypeGet:
            return [[ScheduleAPIManager alloc] init];
            break;
        case ScheduleAPIManagerTypeUpdate:
            return [[ScheduleUpdateAPIManager alloc] init];
            break;
        default:
            break;
    }
}

@end
