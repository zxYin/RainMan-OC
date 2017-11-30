//
//  UserAPIManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserAPIManager.h"

@implementation UserAPIManager
- (NSString *)path {
    return @"stuInfo/getStuInfo/";
}

- (NSString *)apiVersion {
    return @"2.0";
}

- (BOOL)isAuth {
    return YES;
}

- (BOOL)shouldCache {
    return YES;
}

- (id)fetchData {
    return [super fetchData][@"data"][@"user_info"];
}

@end
