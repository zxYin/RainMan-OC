//
//  NoticeAPIManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/1/9.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "NoticeAPIManager.h"

@implementation NoticeAPIManager
- (NSString *)path {
    return @"extra/getNotices/"
#ifdef DEBUG
            "debug/"
#endif
            ;
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

- (id)fetchData {
    return [super fetchData][@"data"];
}

@end
