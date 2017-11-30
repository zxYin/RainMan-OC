//
//  WebClassroomAPIManager.m
//  LKClassroomModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WebClassroomAPIManager.h"

@implementation WebClassroomAPIManager
- (NSString *)path {
    return @"campusInfo/getIdleClassroom/";
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
    return [[super fetchData][@"data"] firstObject];
}

@end
