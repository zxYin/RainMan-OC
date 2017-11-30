//
//  NSDictionary+LKValueGetter.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LKValueGetter)
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSURL *)URLForKey:(NSString *)key;
- (NSURL *)URLForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;

- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (NSArray *)arrayForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
@end
