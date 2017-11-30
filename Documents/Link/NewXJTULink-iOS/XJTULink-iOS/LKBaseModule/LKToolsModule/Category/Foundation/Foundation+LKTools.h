//
//  Foundation+LKTools.h
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Base64.h"
#import "NSData+Base64.h"

#define SafeType(obj, clazz) [obj safeType:clazz]

@interface NSObject (Swizzling)
+ (void) methodSwizzlingWithTarget:(SEL)originalSelector
                             using:(SEL)swizzledSelector
                          forClass:(Class)clazz;
- (id)safeType:(Class)clazz;
@end


@interface NSString (LKTools)
+ (BOOL)notBlank:(NSString *)str;
+ (BOOL)isBlank:(NSString *)str;
- (NSInteger)trueLength;
- (BOOL)isPureNumandCharacters;
- (NSString *)stringByTrimmingDefault;

- (NSString *)stringByURLEncoding;
- (NSString *)stringByURLDecoding;

- (NSString *)stringbyRemoveAllNewline;
- (NSString *)stringByDecodingXMLEntities;
@end

@interface NSDictionary (LKTools)
- (NSString *)JSONString;
- (NSString *)JSONStringWithError:(NSError **)error;

/// 注意此方法没有经过URLEncoding
- (NSString *)URLQueryString;
- (NSString *)URLQueryStringWithoutEncoding;

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)string;
+ (NSDictionary *)dictionaryWithURLQueryString:(NSString *)query;
@end



