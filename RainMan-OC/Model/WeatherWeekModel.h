//
//  Week.h
//  RainMan-OC
//
//  Created by 殷子欣 on 2017/4/22.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

#import "WeatherDayModel.h"
#import <Foundation/Foundation.h>
@interface WeatherWeekModel : NSObject
@property (nonatomic, strong) NSMutableArray<WeatherDayModel *> *dayWeathers;
- (void)weekWeatherModel:(NSDictionary*)mainWeatherDict;
@end
