//
//  LectureListAPIManager.m
//  LKActivityModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureListAPIManager.h"
#import "LectureModel.h"
#import <Mantle/Mantle.h>

@interface LectureListAPIManager()

@end

@implementation LectureListAPIManager
#pragma mark - YLAPIManager
- (NSString *)path {
    return @"campusInfo/getLectureList/";
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

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"begin"] = @(self.currentPage * self.pageSize);
    resultParams[@"num"] = @(self.pageSize);
    return resultParams;
}

#pragma mark -
- (NSString *)keyOfResult {
    return @"lectures";
}
@end
