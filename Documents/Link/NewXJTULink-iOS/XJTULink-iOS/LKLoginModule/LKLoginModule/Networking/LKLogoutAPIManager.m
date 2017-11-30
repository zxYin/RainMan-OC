//
//  LKLogoutAPIManager.m
//  LKLoginModule
//
//  Created by Yunpeng on 2016/12/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLogoutAPIManager.h"

@implementation LKLogoutAPIManager
- (NSString *)path {
    return @"auth/logout/";
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


@end
