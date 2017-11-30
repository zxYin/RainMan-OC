//
//  LikeAPIManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LikeAPIManager.h"

@implementation LikeAPIManager
- (NSString *)path {
    return @"wall/like/";
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
    
- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params {
    if (params.count <= 2) {
        return NO;
    }
    return YES;
}

@end
