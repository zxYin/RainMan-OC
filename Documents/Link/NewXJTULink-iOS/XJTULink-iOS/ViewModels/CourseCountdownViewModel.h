//
//  CourseCountdownViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseCountdownViewModel : NSObject
@property (nonatomic, assign) BOOL isClassTime;
@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, copy) NSString *rightText;
@property (nonatomic, copy) NSString *leftText;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *second;
@end
