//
//  AccessoryAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AccessoryAPIManager.h"
#import <Mantle/Mantle.h>
 NSString * const kAccessoryAPIManagerParamsKeyNewsId = @"kAccessoryAPIManagerParamsKeyNewsId";

@implementation AccessoryAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"campusInfo/getNewsAccessory/";
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

- (id)fetchDataFromModel:(Class)clazz {
    return [MTLJSONAdapter modelsOfClass:clazz
                           fromJSONArray:[super fetchData][@"data"][@"accessory"]
                                   error:nil];
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"news_id"] = params[kAccessoryAPIManagerParamsKeyNewsId];
    
    
    
    return resultParams;
}

@end
