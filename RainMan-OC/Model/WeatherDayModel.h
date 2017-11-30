//
//  OneDayOfOneWeek.h
//  RainMan-OC
//
//  Created by 殷子欣 on 2017/4/15.
//  Copyright © 2017年 yinzixin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WeatherDayModel : NSObject
@property(nonatomic, assign) NSInteger temperatureMax;
@property(nonatomic, assign) NSInteger temperatureMin;
@property(nonatomic, retain) UIImage *iconImage;
@property(nonatomic, assign) NSInteger name;
@end
