//
//  NSString+Date.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/6/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
+ (NSString *)weekdayStringFrom:(NSInteger)weekday {
    if (weekday< 0 || weekday >7) {
        return nil;
    }
    NSArray *weekdays = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"];
    return weekdays[weekday];
}
+ (NSString *)weekStringFrom:(NSInteger)week {
    NSArray *numbers = @[@"",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
    if (week<0) {
        return nil;
    }else if(week==0){
        return numbers[1];
    } else if (week<=10) {
        return numbers[week];
    } else if (week<20) {
        return [NSString stringWithFormat:@"十%@",numbers[week%10]];
    } else if (week<30) {
        return [NSString stringWithFormat:@"二十%@",numbers[week%10]];
    }
    return nil;
}
@end
