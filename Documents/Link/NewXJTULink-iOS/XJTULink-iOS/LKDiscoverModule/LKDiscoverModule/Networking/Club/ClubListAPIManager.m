//
//  ClubListAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubListAPIManager.h"
#import <Mantle/Mantle.h>

NSString * const kClubListAPIManagerParamsKeyClubTypeId = @"kClubListAPIManagerParamsKeyClubTypeId";
@implementation ClubListAPIManager
- (NSString *)path {
    return @"clubInfo/getClubList/";
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
    resultParams[@"type"] = params[kClubListAPIManagerParamsKeyClubTypeId];
    resultParams[@"begin"] = @(self.currentPage * self.pageSize);
    resultParams[@"num"] = @(self.pageSize);
    return resultParams;
}

- (NSString *)keyOfResult {
    return @"clubs";
}
@end
