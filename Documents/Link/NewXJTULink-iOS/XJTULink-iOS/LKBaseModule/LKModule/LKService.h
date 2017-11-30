//
//  LKService.h
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSDictionary+LKValueGetter.h"

@class LKService;
LKService * LKServiceFromString(NSString *str);

@protocol LKSelfManager <NSObject>
- (void)setNeedUpdate;
- (void)whenTap:(void (^)(id obj))block;
@end

#define AUTH_REQUIRE(...) \
- (BOOL)shouldLoginBeforeAction:(NSString *)action { \
    static dispatch_once_t onceToken; \
    static NSSet *loginRequireSet; \
    dispatch_once(&onceToken, ^{ \
        loginRequireSet = [NSSet setWithObjects:__VA_ARGS__, nil]; \
    }); \
    if ([loginRequireSet containsObject:action] \
        || [loginRequireSet containsObject:[NSString stringWithFormat:@"%@_%@",self.class.prefix,action]] \
    ) { \
        return YES; \
    } \
    return NO; \
}

@interface LKService : NSObject

+ (NSString *)title;
+ (NSString *)prefix;

- (BOOL)isEnable;
- (BOOL)shouldLoginBeforeAction:(NSString *)action;
@end



// 需要异步寄存Service，就放到这里面
@interface LKServicePool : NSObject
+ (instancetype)sharedInstance;
- (BOOL)containsType:(Class)clazz;
- (void)registerService:(LKService *)service;
- (void)removeService:(LKService *)service;
@end
