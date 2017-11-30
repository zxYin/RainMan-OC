//
//  WeekAPIManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WeekAPIManager.h"
#import "DateTools.h"
#import "Foundation+LKTools.h"

@implementation WeekAPIManager
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"campusInfo/getCurrentWeek/";
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
    return @([[super fetchData][@"data"] integerForKey:@"current_week"]);
}


@end
