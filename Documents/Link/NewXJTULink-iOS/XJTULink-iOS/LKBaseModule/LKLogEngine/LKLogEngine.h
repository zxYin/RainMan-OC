//
//  LKLogEngine.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLogConfig.h"
typedef NS_ENUM(NSInteger, LKLogLevel) {
    LKLogLevelDebug, 
    LKLogLevelInfo,
    LKLogLevelWarning,
    LKLogLevelError,
};

#define LKDebug(LOG, PARAMS) [LKLogEngine logEvent:LOG level:LKLogLevelDebug params:PARAMS]
#define LKInfo(LOG, PARAMS) [LKLogEngine logEvent:LOG level:LKLogLevelInfo params:PARAMS]
#define LKWarning(LOG, PARAMS) [LKLogEngine logEvent:LOG level:LKLogLevelWarning params:PARAMS]
#define LKError(LOG, PARAMS)    [LKLogEngine logEvent:LOG level:LKLogLevelError params:PARAMS]

@interface LKLogEngine : NSObject
+ (void)setup;
+ (void)logEvent:(NSString *)name level:(LKLogLevel)level params:(NSDictionary *)params;
@end
