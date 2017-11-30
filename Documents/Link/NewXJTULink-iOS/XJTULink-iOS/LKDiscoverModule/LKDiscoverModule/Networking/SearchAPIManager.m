//
//  SearchAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SearchAPIManager.h"
#import "ClubModel.h"
#import "Foundation+LKTools.h"
#import "SingleURLModel.h"
NSString * const kSearchAPIManagerParamsKeyKeywords = @"kSearchAPIManagerParamsKeyKeywords";

@implementation SearchAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"integrate/search/";
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

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params {
    if ([NSString isBlank:params[@"keyword"]]) {
        return NO;
    }
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"keyword"] = params[kSearchAPIManagerParamsKeyKeywords];
    
    return resultParams;
}


@end
