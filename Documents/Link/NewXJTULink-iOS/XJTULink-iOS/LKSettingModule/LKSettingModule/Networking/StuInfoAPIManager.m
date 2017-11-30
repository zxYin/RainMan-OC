//
//  StuInfoAPIManager.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "StuInfoAPIManager.h"
NSString * const kStuInfoAPIManagerParamsKeyNickname = @"kStuInfoAPIManagerParamsKeyNickname";
@implementation StuInfoAPIManager
- (NSString *)path {
    return @"stuInfo/putStuNickName/";
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
    resultParams[@"nickname"] = params[kStuInfoAPIManagerParamsKeyNickname];
    return resultParams;
}

- (id)fetchData {
    return [super fetchData][@"data"];
}
@end
