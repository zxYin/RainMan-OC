//
//  ActivityListAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityListAPIManager.h"
#import <Mantle/Mantle.h>

NSString * const kActivityListAPIManagerParamsKeyClubId = @"kActivityListAPIManagerParamsKeyClubId";

@implementation ActivityListAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"activity/getClubDefaultActivities/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return NO;
}

- (BOOL)shouldCache {
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"club_id"] = params[kActivityListAPIManagerParamsKeyClubId];
    
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"activities";
}



@end
