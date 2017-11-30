//
//  LKLogFormatter.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLogFormatter.h"
#import "Foundation+LKTools.h"
#import "LKLogConfig.h"

@implementation LKLogFormatter {
//    int loggerCount;
//    NSDateFormatter *threadUnsafeDateFormatter;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
//    NSString *logLevel;
//    switch (logMessage->_flag) {
//        case DDLogFlagError    : logLevel = @"error"; break;
//        case DDLogFlagWarning  : logLevel = @"warning"; break;
//        case DDLogFlagInfo     : logLevel = @"info"; break;
//        case DDLogFlagDebug    : logLevel = @"debug"; break;
//        default                : logLevel = @"undefined"; break;
//    }
//    
//    NSDictionary *params = [NSDictionary dictionaryWithJSONString:logMessage->_message];
//    
//    NSMutableDictionary *logEvent;
//    logEvent[LKLogParamsKeyStatus] = params[LKLogParamsKeyStatus];
//    logEvent[LKLogParamsKeyCurrentPage] = params[LKLogParamsKeyCurrentPage];
//    logEvent[LKLogParamsKeyExtra] = params[LKLogParamsKeyExtra];
//    
//    logEvent[@"level"] = logLevel;
//    logEvent[@"time"] = logMessage->_timestamp;
//    logEvent[@"event"] = logMessage->_message;
    NSLog(@"[LKLogEngine]:%@",logMessage->_message);
    return logMessage->_message;
}
@end
