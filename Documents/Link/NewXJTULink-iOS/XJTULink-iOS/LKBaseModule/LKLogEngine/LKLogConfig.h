//
//  LKLogConfig.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef LKLogConfig_h
#define LKLogConfig_h

static NSString * const LKLogEventPage = @"page_event";
static NSString * const LKLogEventRequest = @"request_event";

static NSInteger const LKLogConfigSendInterval = 90;
static NSInteger const LKLogConfigFileMaxSize = 100 * 1024; // 单位是 B
static NSInteger const LKLogConfigFileMaxLine = 1000;

#endif /* LKLogConfig_h */
