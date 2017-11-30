//
//  TCourse.m
//  XJTUIn
//
//  Created by 李云鹏 on 7/1/15.
//  Copyright (c) 2015 李云鹏. All rights reserved.
//

#import "CourseModel.h"
#import "Foundation+LKTools.h"
#import "Foundation+LKCourse.h"

@interface CourseModel ()
@property (nonatomic, copy) WeekFormatter *weekFormatter;
@end
@implementation CourseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _uuid = [[NSUUID UUID] UUIDString];
        _timeRange = NSMakeRange(1, 2); // default
        _weekday = 0; // default
        _week = @"1-16";
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"找不到key:%@, 忽略",key);
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"name":@"course_name",
            @"locale":@"classroom",
            @"timeRange":@"course_time",
            @"week":@"week_time",
            @"weekday":@"week_day",
            @"teachers":@"teachers",
    };
}

+ (NSValueTransformer *)timeRangeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {

        NSString *pattern = @"(\\d+).(\\d+)";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                    options:0
                                                                                      error:NULL];
        NSTextCheckingResult *result = [expression firstMatchInString:value
                                                              options:0
                                                                range:NSMakeRange(0, value.length)];
        
        NSInteger start = [[value substringWithRange:[result rangeAtIndex:1]] integerValue] ;
        NSInteger end = [[value substringWithRange:[result rangeAtIndex:2]] integerValue];
        
        return [NSValue valueWithRange:NSMakeRange(start, end-start+1)];
    }];
}

+ (NSValueTransformer *)weekdayJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return @([value weekdayValue]);
    }];
}

- (WeekFormatter *)weekFormatter {
    if (_weekFormatter == nil) {
        _weekFormatter = [WeekFormatter formatterWithString:self.week];
    }
    return _weekFormatter;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToCourse:other];
}

- (BOOL)isEqualToCourse:(CourseModel *)aCourse {
    if (self == aCourse)
        return YES;
    if (![(id)[self name] isEqual:[aCourse name]])
        return NO;
    if (![(id)[self locale] isEqual:[aCourse locale]])
        return NO;
    if (!NSEqualRanges(self.timeRange, aCourse.timeRange))
        return NO;
    if (self.weekday != aCourse.weekday)
        return NO;
    if (![(id)[self teachers] isEqualToArray:[aCourse teachers]])
        return NO;
    if (![[self week] isEqual:[aCourse week]])
        return NO;
    return YES;  
}


- (NSComparisonResult)compare:(CourseModel *)course {
    if (self.timeRange.location < course.timeRange.location) {
        return NSOrderedAscending;
    } else if(self.timeRange.location > course.timeRange.location) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (void)updateFromModel:(CourseModel *)model {
    self.name = model.name;
    self.locale = model.locale;
    self.week = [model.weekFormatter groupedString];
    self.weekFormatter = model.weekFormatter;
    self.weekday = model.weekday;
    self.teachers = model.teachers;
    self.timeRange = model.timeRange;
}

- (BOOL)isConflictWith:(CourseModel *)course {
    if (course == nil) { return NO; }
    
    if ([self.uuid isEqualToString:course.uuid]) {
        return NO;
    }
    
    // 在周内的同一天
    if (self.weekday != course.weekday) { return NO; }
    
    // 含有同样的周
    __block BOOL isContainSameWeek = NO;
    [self.weekFormatter.indexSet enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
        if ([course.weekFormatter.indexSet intersectsIndexesInRange:range]) {
            isContainSameWeek = YES;
            *stop = YES;
        }
    }];

    if (!isContainSameWeek) { return NO; }
    
    return LKRangeIntersects(self.timeRange, course.timeRange);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[Course]name:%@,locale:%@,time:%@,week:%@,weekday:%td",
            self.name,self.locale,NSStringFromRange(self.timeRange),self.week,self.weekday];
}

@end
