//
//  NSUserDefaults+LKTools.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSUserDefaults+LKTools.h"

@implementation NSUserDefaults (LKTools)
- (void)switchBoolForKey:(NSString *)key {
    BOOL origin = [self boolForKey:key];
    [self setBool:!origin forKey:key];
}

- (BOOL)hasKey:(NSString *)key {
    id value = [self objectForKey:key];
    return (value != nil);
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    BOOL result = defaultValue;
    id value = [self objectForKey:key];
    if (value != nil) {
        result = [value boolValue];
    }
    return result;
}

@end
