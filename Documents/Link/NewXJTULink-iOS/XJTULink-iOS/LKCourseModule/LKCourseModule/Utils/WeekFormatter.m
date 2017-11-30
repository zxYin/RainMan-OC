//
//  WeekFormatter.m
//  TestA
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WeekFormatter.h"

@interface NSIndexSet(WeekFormatter)
- (NSString *)groupedString;
@end

@implementation NSIndexSet (WeekFormatter)

- (NSString *)groupedString {
    NSMutableString *result = [NSMutableString string];
    [self enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
        if(range.length > 1) {
            [result appendFormat:@"%td-%td,", range.location,range.location + range.length - 1];
        } else {
            [result appendFormat:@"%td,",range.location];
        }
    }];
    
    if ([result length] > 0) {
        [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
    }
    return [result copy];
}
@end


@interface WeekFormatter ()
@property (nonatomic, assign) WeekType type;
@property (nonatomic, copy) NSIndexSet *indexSet;

@property (nonatomic, copy) NSString *rawString;
@property (nonatomic, copy) NSString *groupedString;
@end

@implementation WeekFormatter
- (instancetype)initWithString:(NSString *)str {
    self = [super init];
    if (self) {
        self.rawString = str;
        [self analyze];
    }
    return self;
}
+ (instancetype)formatterWithString:(NSString *)str {
    return [[WeekFormatter alloc] initWithString:str];
}

- (void)analyze {
    if ([self.rawString containsString:@"单"]) {
        self.type = WeekTypeOdd;
    } else if([self.rawString containsString:@"双"]) {
        self.type = WeekTypeEven;
    }
    
    NSArray *rawWeeks = [self.rawString componentsSeparatedByString:@","];
    NSMutableIndexSet *weekSet = [NSMutableIndexSet indexSet];
    for (NSString *tmp in rawWeeks) {
        NSRange range = [tmp rangeOfString:@"(\\d+)-(\\d+)" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            [weekSet addIndex:[tmp integerValue]];
        } else {
            NSArray *pair = [[tmp substringWithRange:range] componentsSeparatedByString:@"-"];
            for (NSInteger i = [pair[0] integerValue]; i<= [pair[1] integerValue]; i++) {
                BOOL isLegal = YES;
                switch (self.type) {
                    case WeekTypeOdd:
                        isLegal = (i % 2 == 1);
                        break;
                    case WeekTypeEven:
                        isLegal = (i % 2 == 0);
                        break;
                    default:
                        break;
                }
                if (isLegal) {
                    [weekSet addIndex:i];
                }
            }
        }
    }
    
    self.indexSet = [weekSet copy];
    self.groupedString = [weekSet groupedString];
}

@end
