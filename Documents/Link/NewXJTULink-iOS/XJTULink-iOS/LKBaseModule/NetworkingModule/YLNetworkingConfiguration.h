//
//  YLNetworkingConfiguration.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef YLNetworkingConfiguration_h
#define YLNetworkingConfiguration_h

#define YLNetworkingLog TRUE

#import "Constants.h"
typedef NS_ENUM(NSUInteger, YLResponseStatus) {
    // 底层仅有这四种状态
    YLResponseStatusSuccess,
    YLResponseStatusCancel,
    YLResponseStatusErrorTimeout,
    YLResponseStatusErrorUnknown,
};

static BOOL kYLAutoRefreshToken = YES;
static BOOL kYLShouldCacheDefault = NO;
static BOOL kYLServiceIsOnline = NO;
static NSTimeInterval kYLNetworkingTimeoutSeconds = 20.0f;
static NSTimeInterval kYLCacheExpirationTimeDefault = 60 * 5; // 5分钟的cache过期时间

#endif /* YLNetworkingConfiguration_h */
