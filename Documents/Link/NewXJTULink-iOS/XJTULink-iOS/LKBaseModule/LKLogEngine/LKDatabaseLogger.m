//
//  LKDatabaseLogger.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKDatabaseLogger.h"
@interface LKDatabaseLogger() {
    NSMutableArray *_logMessagesArray;
}
@end
@implementation LKDatabaseLogger
- (instancetype)init {
    self = [super init];
    if (self) {
        self.deleteInterval = 0;
        self.maxAge = 0;
        self.deleteOnEverySave = NO;
        self.saveInterval = 60;
        self.saveThreshold = 500;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveOnSuspend)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}


- (BOOL)db_log:(DDLogMessage *)logMessage {
    if (!_logFormatter) {
        return NO;
    }

    if (!_logMessagesArray) {
        _logMessagesArray = [NSMutableArray arrayWithCapacity:1000];
    }
    
    if ([_logMessagesArray count] > 2000) {
        // Too much logging is coming in too fast. Let's not put this message in the array
        // However, we want the abstract logger to retry at some time later, so
        // let's return YES, so the log message counters in the abstract logger keeps getting incremented.
        return YES;
    }
    
    [_logMessagesArray addObject:[self->_logFormatter formatLogMessage:logMessage]];
    return YES;

}


- (void)db_save{
    if (![self isOnInternalLoggerQueue]) {
        NSAssert(NO, @"db_saveAndDelete should only be executed on the internalLoggerQueue thread, if you're seeing this, your doing it wrong.");
    }
    
    // If no log messages in array, just return
    if ([_logMessagesArray count] == 0) {
        return;
    }
    
    // Get reference to log messages
    NSArray *oldLogMessagesArray = [_logMessagesArray copy];
    
    // reset array
    _logMessagesArray = [NSMutableArray arrayWithCapacity:0];
    
    // Create string with all log messages
    NSString *logMessagesString = [oldLogMessagesArray componentsJoinedByString:@"\n"];
    
    // Post string to Loggly
    [self doPostToServer:logMessagesString];
}

- (void)doPostToServer:(NSString *)message {
    NSLog(@"上传日志到服务器上去");
    
}


- (void)saveOnSuspend {
    
#ifdef DEBUG
    NSLog(@"挂起，发送日志到服务器");
#endif
    dispatch_async(_loggerQueue, ^{
        [self db_save];
    });
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
