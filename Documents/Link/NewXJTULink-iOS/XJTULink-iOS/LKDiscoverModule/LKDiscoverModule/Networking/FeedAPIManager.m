//
//  FeedAPIManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FeedAPIManager.h"
#import "FeedModel.h"
@implementation FeedAPIManager
- (NSString *)path {
    return @"integrate/feed/";
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

@end
