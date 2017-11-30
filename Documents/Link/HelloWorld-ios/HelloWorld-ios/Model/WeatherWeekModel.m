//
//  Week.m
//  HelloWorld-ios
//
//  Created by 殷子欣 on 2017/4/22.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

#import "WeatherWeekModel.h"
@implementation WeatherWeekModel

#pragma mark -Life Cycle
- (id)init {
    if (self = [super init]) {
        self.dayWeathers = [[NSMutableArray alloc] init];
        for (NSInteger count=0; count<7; count++) {
            WeatherDayModel *weekDayModel = [[WeatherDayModel alloc] init];
            [self.dayWeathers addObject:weekDayModel];
        }
    }
    return self;
}

#pragma mark - Public API

#pragma mark - Private API

#pragma mark - Getter && Setter
//获取今天是星期几
- (NSInteger)weekdayInteger {
    NSDate *weatherDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components: NSCalendarUnitWeekday fromDate:weatherDate];
    NSInteger weekDay = [comps weekday];
    //NSLog(@"%td", weekDay);
    return weekDay;
}


- (void)weekWeatherModel:(NSDictionary *)mainWeatherDict {
    //星期几更新完毕
    NSInteger todayWeekDay = [self weekdayInteger] - 1;
    for (NSInteger count=0; count<7; count++) {
        self.dayWeathers[count].name = (todayWeekDay+count <= 7) ? (todayWeekDay + count) : (todayWeekDay + count - 7);
    }
    //更新最高气温最低气温
    if ([mainWeatherDict[@"daily"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dailyDictionary = mainWeatherDict[@"daily"];
        if ([dailyDictionary[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *weathers = dailyDictionary[@"data"];
            for (NSInteger count = 0; count <7; count++) {
                if ([weathers[count] isKindOfClass:[NSDictionary class]]) {
                    self.dayWeathers[count].temperatureMax = [weathers[count][@"temperatureMax"] floatValue];
                    self.dayWeathers[count].temperatureMin = [weathers[count][@"temperatureMin"] floatValue];
                    self.dayWeathers[count].iconImage = [UIImage imageNamed:weathers[count][@"icon"]];
                    //NSLog(@"%@", weathers[count][@"icon"]);
                }
            }
        }
    }

}
@end
