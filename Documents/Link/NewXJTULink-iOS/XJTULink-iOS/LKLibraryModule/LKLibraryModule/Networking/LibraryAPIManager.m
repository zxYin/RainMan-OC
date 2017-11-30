//
//  LibraryAPIManager.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryAPIManager.h"
NSString * const kLibraryAPIManagerParamsKeyLibUsername = @"kLibraryAPIManagerParamsKeyLibUsername";
NSString * const kLibraryAPIManagerParamsKeyLibPassword = @"kLibraryAPIManagerParamsKeyLibPassword";

@implementation LibraryAPIManager
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - YLAPIManager

- (NSString *)path {
    return @"stuInfo/library/";
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
    resultParams[@"lib_username"] = params[kLibraryAPIManagerParamsKeyLibUsername];
    resultParams[@"lib_password"] = params[kLibraryAPIManagerParamsKeyLibPassword];
    return resultParams;
}

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params {
    if (params.count < 4) {
        return NO;
    }
    return YES;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}



@end
