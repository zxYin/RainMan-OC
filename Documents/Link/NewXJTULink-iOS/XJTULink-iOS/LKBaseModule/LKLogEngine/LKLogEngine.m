//
//  LKLogEngine.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLogEngine.h"
#import "CocoaLumberjack.h"
#import "Foundation+LKTools.h"
#import "LKLogFormatter.h"
#import "LKDatabaseLogger.h"
@implementation LKLogEngine
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#endif
+ (void)setup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LKDatabaseLogger *logger = [[LKDatabaseLogger alloc] init];
        LKLogFormatter *formatter = [[LKLogFormatter alloc] init];
        [logger setLogFormatter:formatter];
        [DDLog addLogger:logger];
    });
}

+ (void)logEvent:(NSString *)name level:(LKLogLevel)level params:(NSDictionary *)params {
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[@"name"] = name;
    messageDict[@"time"] = @([NSDate timeIntervalSinceReferenceDate]);
//    messageDict[@"current_page"] =
    messageDict[@"level"] = @(level);
    messageDict[@"extra"] = params;
    NSString *message = [[messageDict JSONString] stringbyRemoveAllNewline];;
    
    switch (level) {
        case LKLogLevelDebug:
            DDLogDebug(@"%@", message);
            break;
        case LKLogLevelInfo:
            DDLogInfo(@"%@", message);
            break;
        case LKLogLevelWarning:
            DDLogWarn(@"%@", message);
            break;
        case LKLogLevelError:
            DDLogError(@"%@", message);
            break;
        default:
            break;
    }
}
@end
