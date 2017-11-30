//
//  NSDictionary+LKValueGetter.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSDictionary+LKValueGetter.h"
#import "Foundation+LKTools.h"
@implementation NSDictionary (LKValueGetter)
- (NSInteger)integerForKey:(NSString *)key {
    return [self integerForKey:key defaultValue:0];
}
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(integerValue)] ? [value integerValue] : defaultValue;
}

- (NSString *)stringForKey:(NSString *)key {
    return [self stringForKey:key defaultValue:nil];
}
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return (defaultValue != nil && [NSString isBlank:value])?defaultValue:value;
    }
    return [value respondsToSelector:@selector(stringValue)] ? [value stringValue] : defaultValue;
}

- (NSURL *)URLForKey:(NSString *)key {
    return [self URLForKey:key defaultValue:nil];
}

- (NSURL *)URLForKey:(NSString *)key defaultValue:(NSURL *)defaultValue {
    NSString *value = [self stringForKey:key];
    if ([NSString isBlank:value]) {
        return defaultValue;
    } else {
        return [NSURL URLWithString:[value stringByURLEncoding]];
    }
}


- (BOOL)boolForKey:(NSString *)key {
    return [self boolForKey:key defaultValue:NO];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id value = [self objectForKey:key];
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return defaultValue;
    }
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [self arrayForKey:key defaultValue:nil];
}

- (NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
     return [self dictionaryForKey:key defaultValue:nil];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

@end
