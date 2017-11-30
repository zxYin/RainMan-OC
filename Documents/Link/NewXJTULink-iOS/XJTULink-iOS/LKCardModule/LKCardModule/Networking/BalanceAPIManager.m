//
//  BalanceAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "BalanceAPIManager.h"
#import <Mantle/Mantle.h>
#import "LKNetworking.h"

@implementation BalanceAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"stuInfo/getStuBalance/";
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
    return 20;
}

- (NSString *)keyOfResult {
    return @"balance";
}
@end
