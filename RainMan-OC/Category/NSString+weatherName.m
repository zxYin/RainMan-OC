//
//  NSString+weatherToWeatherName.m
//  RainMan-OC
//
//  Created by 殷子欣 on 2017/5/1.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

#import "NSString+weatherName.h"

@implementation NSString (WeatherName)
- (NSString *)weatherName {
    if ([self isEqualToString:@"clear-day"]) {
        return @"晴天";
    }
    else if ([self isEqualToString:@"clear-day"]) {
        return @"晴天";
    }
    else if ([self isEqualToString:@"clear-night"]) {
        return @"晴天";
    }
    else if ([self isEqualToString:@"cloudy"]) {
        return @"阴天";
    }
    else if ([self isEqualToString:@"fog"]) {
        return @"雾";
    }
    else if ([self isEqualToString:@"partly-cloudy-day"]) {
        return @"多云";
    }
    else if ([self isEqualToString:@"partly-cloudy-night"]) {
        return @"多云";
    }
    else if ([self isEqualToString:@"rain"]) {
        return @"雨天";
    }
    else if ([self isEqualToString:@"sleet"]) {
        return @"雨夹雪";
    }
    else if ([self isEqualToString:@"snow"]) {
        return @"雪天";
    }
    else if ([self isEqualToString:@"wind"]) {
        return @"大风";
    }else return @"未知";
}

@end
