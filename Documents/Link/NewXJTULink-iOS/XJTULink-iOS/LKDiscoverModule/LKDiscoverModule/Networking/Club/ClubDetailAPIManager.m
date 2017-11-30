//
//  ClubAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubDetailAPIManager.h"
NSString * const kClubDetailAPIManagerParamsKeyClubId = @"kClubDetailAPIManagerParamsKeyClubId";
@implementation ClubDetailAPIManager
- (NSString *)path {
    return @"clubInfo/getClubDetail/";
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
    resultParams[@"club_id"] = params[kClubDetailAPIManagerParamsKeyClubId];
    return resultParams;
}

@end
