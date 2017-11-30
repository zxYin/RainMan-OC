//
//  CourseDetailHeaderView.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseDetailHeaderView.h"

@implementation CourseDetailHeaderView

+ (instancetype)headerView {
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"CourseDetailHeaderView" owner:nil options:nil];
    return [nibViews firstObject];
}
@end
