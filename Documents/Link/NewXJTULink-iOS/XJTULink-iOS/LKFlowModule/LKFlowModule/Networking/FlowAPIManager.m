//
//  FlowAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FlowAPIManager.h"
NSString * const kFlowAPIManagerParamsKeyIsDetail = @"kFlowAPIManagerParamsKeyIsDetail";
@implementation FlowAPIManager
- (NSString *)path {
    return @"stuInfo/getStuFlow/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return YES;
}

- (NSInteger)cacheExpirationTime {
    return 24 * 60 * 60;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"is_detail"] = params[kFlowAPIManagerParamsKeyIsDetail];
    return resultParams;
}
@end
