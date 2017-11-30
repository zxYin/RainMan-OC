//
//  ConfessionAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostAPIManager.h"
NSString * const kPostAPIManagerParamsKeyId = @"kPostAPIManagerParamsKeyId";

NSString * const kPostAPIManagerParamsKeyContent = @"kPostAPIManagerParamsKeyContent";
NSString * const kPostAPIManagerParamsKeyReferName = @"kPostAPIManagerParamsKeyReferName";
NSString * const kPostAPIManagerParamsKeyReferAcademy = @"kPostAPIManagerParamsKeyReferAcademy";
NSString * const kPostAPIManagerParamsKeyReferClass = @"kPostAPIManagerParamsKeyReferClass";

NSString * const kPostAPIManagerParamsKeyCommunityId = @"kPostAPIManagerParamsKeyCommunityId";
NSString * const kPostAPIManagerParamsKeyOptionId = @"kPostAPIManagerParamsKeyOptionId";
@interface LKPostSubmitAPIManager : LKPostAPIManager
@end

@implementation LKPostSubmitAPIManager
- (NSString *)path {
    return @"wall/postConfession/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"content"] = params[kPostAPIManagerParamsKeyContent];
    resultParams[@"community_id"] = params[kPostAPIManagerParamsKeyCommunityId];
    resultParams[@"option_id"] = params[kPostAPIManagerParamsKeyOptionId];
    
    NSMutableDictionary *referStudent = [[NSMutableDictionary alloc] init];
    referStudent[@"name"] = params[kPostAPIManagerParamsKeyReferName];
    if (referStudent.count > 0) {
        referStudent[@"academy"] = params[kPostAPIManagerParamsKeyReferAcademy]?:@"";
        referStudent[@"class"] = params[kPostAPIManagerParamsKeyReferClass]?:@"";
        resultParams[@"refer_student"] = [referStudent copy];
    }
    
    return @{
             @"confession":resultParams,
             };
}

- (NSString *)keyOfResult {
    return @"confession";
}

@end
//////////////////////////////////////////////////////////////////////////////////////

// 这个仅在用户进入详情页时调用
@interface LKPostViewAPIManager : LKPostAPIManager
@end

@implementation LKPostViewAPIManager
- (NSString *)path {
    return @"wall/viewConfession/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"confession_id"] = params[kPostAPIManagerParamsKeyId];
    return resultParams;
}

@end

//////////////////////////////////////////////////////////////////////////////////////
@interface LKPostDeleteAPIManager : LKPostAPIManager
@end

@implementation LKPostDeleteAPIManager
- (NSString *)path {
    return @"wall/deleteConfession/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"confession_id"] = params[kPostAPIManagerParamsKeyId];
    return resultParams;
}

@end
//////////////////////////////////////////////////////////////////////////////////////
@interface LKPostAcceptAPIManager : LKPostAPIManager
@end

@implementation LKPostAcceptAPIManager
- (NSString *)path {
    return @"wall/acceptConfession/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"confession_id"] = params[kPostAPIManagerParamsKeyId];
    return resultParams;
}

@end
//////////////////////////////////////////////////////////////////////////////////////
@interface LKPostReferAPIManager : LKPostAPIManager
@end

@implementation LKPostReferAPIManager
- (NSString *)path {
    return @"wall/referStudent/";
}

- (NSString *)apiVersion {
    return @"1.0";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"confession_id"] = params[kPostAPIManagerParamsKeyId];
    NSMutableDictionary *referStudent = [[NSMutableDictionary alloc] init];
    referStudent[@"name"] = params[kPostAPIManagerParamsKeyReferName];
    if (referStudent.count > 0) {
        referStudent[@"academy"] = params[kPostAPIManagerParamsKeyReferAcademy]?:@"";
        referStudent[@"class"] = params[kPostAPIManagerParamsKeyReferClass]?:@"";
        resultParams[@"refer_student"] = [referStudent copy];
    }
    return resultParams;
}

@end

//////////////////////////////////////////////////////////////////////////////////////
@implementation LKPostAPIManager
- (NSString *)path {
    return @"wall/getConfessionDetail/";
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
    resultParams[@"confession_id"] = params[kPostAPIManagerParamsKeyId];
    return resultParams;
}

- (NSString *)keyOfResult {
    return @"confession";
}

+ (instancetype)apiManagerByType:(LKPostAPIManagerType)type {
    switch (type) {
        case LKPostAPIManagerTypeGet:
            return [[LKPostAPIManager alloc] init];
        case LKPostAPIManagerTypeView:
            return [[LKPostViewAPIManager alloc] init];
        case LKPostAPIManagerTypeSubmit:
            return [[LKPostSubmitAPIManager alloc] init];
        case LKPostAPIManagerTypeDelete:
            return [[LKPostDeleteAPIManager alloc] init];
        case LKPostAPIManagerTypeAccept:
            return [[LKPostAcceptAPIManager alloc] init];
        case LKPostAPIManagerTypeRefer:
            return [[LKPostReferAPIManager alloc] init];
        default:
            break;
    }
    return nil;
}
@end
