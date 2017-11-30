//
//  LibBook.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/5/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibBookModel.h"

@implementation LibBookModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date":@"date",
             @"name":@"title",
             @"callNumber":@"call_number",
             @"isOrdered":@"is_ordered",
             };
}


- (NSInteger) countdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    NSInteger beginDays = 0;
    if (interval > 0) {
        beginDays =  ((NSInteger)interval)/(60 * 60 * 24) + 1;
    }
    return beginDays;
    
}
@end
