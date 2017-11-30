//
//  WeekHeaderView.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WeekHeaderView.h"
static NSInteger const kBaseTag = 1000;
@implementation WeekHeaderView
- (DayHeaderView *)dayHeaderViewAtIndex:(NSInteger)index {
    return [self viewWithTag:(kBaseTag + index)];
}
+ (instancetype)weekHeaderView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WeekHeaderView" owner:nil options:nil];
    
   return [nibView objectAtIndex:0];
}
@end
