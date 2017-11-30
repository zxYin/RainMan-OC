//
//  LKMessageCountAPIManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageCountAPIManager.h"

@implementation LKMessageCountAPIManager
- (NSString *)path {
    return @"message/getMessageCount/";
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

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];

    return resultParams;
}
@end
