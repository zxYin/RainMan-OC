//
//  WeekHeaderView.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayHeaderView.h"
@interface WeekHeaderView : UIView
- (DayHeaderView *)dayHeaderViewAtIndex:(NSInteger)index;
+ (instancetype)weekHeaderView;
@end
