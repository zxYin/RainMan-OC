//
//  LKModule.m
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
#import <libkern/OSAtomic.h>

LKService * LKServiceFromString(NSString *str) {
    Class serviceClass = NSClassFromString(str);
    if (serviceClass == nil) {
        serviceClass = NSClassFromString([str stringByAppendingString:@"Service"]);
    }
    return [[serviceClass alloc] init];
}

@interface LKService()
//@property (nonatomic, copy) NSString *title;
@end

@implementation LKService
+ (NSString *)title {
    return NSStringFromClass(self);
}

+ (NSString *)prefix {
    NSString *prefix = NSStringFromClass([self class]);
    if ([prefix hasSuffix:@"Service"]) {
        prefix = [prefix substringToIndex:prefix.length - 7];
    }
    return prefix;
}


- (BOOL)isEnable {
    return YES;
}

- (BOOL)shouldLoginBeforeAction:(NSString *)action {
    return NO;
}

@end




@interface LKServicePool(){
    OSSpinLock _lock;
}
@property (nonatomic, strong) NSMutableDictionary<Class,NSMutableSet *> *servicePool;
@end
@implementation LKServicePool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKServicePool *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKServicePool alloc] init];
        instance.servicePool = [[NSMutableDictionary alloc] init];
    });
    return instance;
}

- (BOOL)containsType:(Class)clazz {
    if (clazz == nil) return NO;
    BOOL result = NO;
    OSSpinLockLock(&_lock);
    result = self.servicePool[clazz].count > 0;
    OSSpinLockUnlock(&_lock);
    return result;
}

- (void)registerService:(LKService *)service {
    if (service == nil) return;
    OSSpinLockLock(&_lock);
    NSMutableSet *serviceSet = self.servicePool[service.class];
    if (serviceSet == nil) {
        serviceSet = [[NSMutableSet alloc] init];
        self.servicePool[service.class] = serviceSet;
    }
    [serviceSet addObject:service];
    OSSpinLockUnlock(&_lock);
}

- (void)removeService:(LKService *)service {
    if (service == nil) return;
    OSSpinLockLock(&_lock);
    NSMutableSet *serviceSet = self.servicePool[service.class];
    [serviceSet removeObject:service];
    OSSpinLockUnlock(&_lock);
}
@end
