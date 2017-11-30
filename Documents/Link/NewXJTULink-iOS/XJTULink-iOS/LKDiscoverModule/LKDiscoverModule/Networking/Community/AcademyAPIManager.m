//
//  AcademyAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "AcademyAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
@implementation AcademyAPIManager
- (NSString *)path {
    return @"campusInfo/getAcademyList/";
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

- (id)fetchData {
    return [[super fetchData][@"data"] arrayForKey:@"academy_list"];
}
@end
