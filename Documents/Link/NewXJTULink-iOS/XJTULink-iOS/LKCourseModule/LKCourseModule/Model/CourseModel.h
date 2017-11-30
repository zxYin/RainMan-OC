//
//  TCourse.h
//  XJTUIn
//
//  Created by 李云鹏 on 7/1/15.
//  Copyright (c) 2015 李云鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "WeekFormatter.h"

#define LKTimeFromRange(R) [NSString stringWithFormat:@"%td-%td",R.location, NSMaxRange(R) - 1]

// 判断两个Range是否有交叉 返回BOOL
#define LKRangeIntersects(R1, R2) (NSIntersectionRange(R1, R2).length != 0)

@interface CourseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy, readonly) WeekFormatter *weekFormatter;

@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, copy) NSArray *teachers;
@property (nonatomic, assign) NSRange timeRange;




- (NSComparisonResult)compare:(CourseModel *)model;

// 此处会更新除uuid以外所有的熟悉
- (void)updateFromModel:(CourseModel *)model;

// 上课是否冲突
- (BOOL)isConflictWith:(CourseModel *)course;
@end
