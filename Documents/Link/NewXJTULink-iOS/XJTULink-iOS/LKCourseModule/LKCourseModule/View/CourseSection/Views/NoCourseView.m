//
//  NoCourseView.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NoCourseView.h"

@implementation NoCourseView

+ (instancetype)noCourseView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NoCourseView" owner:nil options:nil];
    return [nibView firstObject];
}
@end
