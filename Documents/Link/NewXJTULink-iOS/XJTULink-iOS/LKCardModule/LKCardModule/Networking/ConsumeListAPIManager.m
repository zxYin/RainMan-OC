//
//  ConsumeListAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ConsumeListAPIManager.h"
#import <Mantle/Mantle.h>

NSString * const kConsumeListAPIManagerParamsKeyFromDate = @"kConsumeListAPIManagerParamsKeyFromDate";
NSString * const kConsumeListAPIManagerParamsKeyToDate = @"kConsumeListAPIManagerParamsKeyToDate";


@interface TodayConsumeListAPIManager : ConsumeListAPIManager

@end

@implementation TodayConsumeListAPIManager
- (NSString *)path {
    return @"stuInfo/getStuTodayConsumeRecord/";
}

- (NSString *)apiVersion {
    return @"1.0";
}
@end


@interface CustomConsumeListAPIManager : ConsumeListAPIManager

@end

@implementation CustomConsumeListAPIManager
- (NSString *)path {
    return @"developTest/getStuConsumeRecord/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"since_id"] = [self sinceId];
    resultParams[@"page_size"] = @(self.pageSize);
    return resultParams;
}

- (NSString *)keyOfResultItemId {
    return @"id";
}
@end


@implementation ConsumeListAPIManager
#pragma mark - YLAPIManager
- (NSString *)path {
     return @"";
}

- (BOOL)isAuth {
    return YES;
}

- (NSString *)apiVersion {
    return @"1.0";
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"consume_list";
}

+ (ConsumeListAPIManager *)apiManagerWithType:(ConsumeType)type {
    switch (type) {
        case ConsumeTypeToday:
            return [[TodayConsumeListAPIManager alloc] initWithPageSize:NSIntegerMax];
        case ConsumeTypeCustom:
            return [CustomConsumeListAPIManager new];
        default:
            return nil;
    }
}
@end








