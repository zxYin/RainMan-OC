//
//  LKVersionAPIManager.m
//  LKStartupModule
//
//  Created by Yunpeng on 2016/12/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKVersionAPIManager.h"

@implementation LKVersionAPIManager
- (NSString *)path {
    return @"extra/getVersion/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (BOOL)isAuth {
    return NO;
}

- (BOOL)shouldCache {
    return NO;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"system"] = @"iOS";
    return resultParams;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}


@end
