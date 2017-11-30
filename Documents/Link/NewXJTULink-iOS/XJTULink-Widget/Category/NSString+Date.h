//
//  NSString+Date.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/6/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
+ (NSString *)weekdayStringFrom:(NSInteger)weekday;
+ (NSString *)weekStringFrom:(NSInteger)week;
@end
