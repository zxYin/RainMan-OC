//
//  Foundation+LKTools.m
//  LKBaseModule
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "Foundation+LKTools.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)
+ (void) methodSwizzlingWithTarget:(SEL)originalSelector
                             using:(SEL)swizzledSelector
                          forClass:(Class)clazz {
    
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(clazz,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(clazz,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (id)safeType:(Class)clazz {
    if ([self isKindOfClass:clazz]) {
        return self;
    } else {
        NSLog(@"[Warnning] %@ is NOT kind of Class %@, which will lead to return nil.",self,clazz);
        return nil;
    }
}
@end

@implementation NSString (LKTools)
+ (BOOL)notBlank:(NSString *)str {
    return
    [str isKindOfClass:[NSString class]]
    && ![self isBlank:str];
}

+ (BOOL)isBlank:(NSString *)str {
    if (str == nil
        || ![str isKindOfClass:[NSString class]]
        || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]
        ) {
        return YES;
    }
    return NO;
}


- (NSInteger)trueLength {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self dataUsingEncoding:enc];
    return [data length];
}

- (BOOL)isPureNumandCharacters
{
    NSString *tmp = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(tmp.length > 0) {
        return NO;
    }
    return YES;
}

- (NSString *)stringByTrimmingDefault {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringbyRemoveAllNewline {
    return [[self stringByReplacingOccurrencesOfString: @"\r" withString: @""]
                  stringByReplacingOccurrencesOfString: @"\n" withString: @""];
}

- (NSString *)stringByURLEncoding {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    return
    (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
// 下面这个方法可能会不正确
//    [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#pragma clang diagnostic pop
}

- (NSString *)stringByURLDecoding {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)stringByDecodingXMLEntities {
    NSUInteger myLength = [self length];
    NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self];
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
            }
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToString:@";" intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
            [scanner scanString:@";" intoString:NULL];
        }
        else {
            NSString *unknownEntity = @"";
            [scanner scanUpToString:@";" intoString:&unknownEntity];
            NSString *semicolon = @"";
            [scanner scanString:@";" intoString:&semicolon];
            [result appendFormat:@"%@%@", unknownEntity, semicolon];
            NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

@end


@implementation NSDictionary (LKTools)
- (NSString *)JSONString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)JSONStringWithError:(NSError **)error {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

- (NSString *)URLQueryString {
    NSMutableString *queryString = [[NSMutableString alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *value = [obj respondsToSelector:@selector(stringByURLEncoding)]?[obj stringByURLEncoding]:obj;
        [queryString appendFormat:@"%@=%@&",key, value];
//         [key respondsToSelector:@selector(stringByURLEncoding)]?[key stringByURLEncoding]:key,
//         [obj respondsToSelector:@selector(stringByURLEncoding)]?[obj stringByURLEncoding]:obj];
    }];
    if (queryString.length > 1) {
        [queryString deleteCharactersInRange:NSMakeRange(queryString.length-1, 1)];
    }
    return [queryString copy];
}

- (NSString *)URLQueryStringWithoutEncoding {
    NSMutableString *queryString = [[NSMutableString alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [queryString appendFormat:@"%@=%@&",key, obj];
    }];
    if (queryString.length > 1) {
        [queryString deleteCharactersInRange:NSMakeRange(queryString.length-1, 1)];
    }
    return [queryString copy];
}

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}



+ (NSDictionary *)dictionaryWithURLQueryString:(NSString *)query {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[[elts lastObject] stringByURLDecoding] forKey:[[elts firstObject] stringByURLDecoding]];
    }
    return [params copy];
}
@end


// 命令行显示utf-8编码的文字
@implementation NSArray (decription)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
@end

@implementation NSDictionary (decription)
- (NSString *)descriptionWithLocale:(id)locale {
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}
@end
