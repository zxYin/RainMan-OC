//
//  CourseEditViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

typedef NS_ENUM(NSInteger, CourseEditItem) {
    kCourseEditItemName = 0,
    kCourseEditItemLocale,
    kCourseEditItemTeachers,
    kCourseEditItemTime,
    kCourseEditItemWeek,
    kCourseEditItemDelete,
};

extern NSString * const kCourseEditItemKeyIcon;
extern NSString * const kCourseEditItemKeyValue;
extern NSString * const kCourseEditItemKeyPlaceholder;
extern NSString * const kCourseEditItemKeyEditable;


@interface CourseEditViewModel : NSObject
@property (nonatomic, assign, readonly) BOOL isConflict;
@property (nonatomic, assign, readonly) BOOL isNew;
@property (nonatomic, copy) CourseModel *model;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *weeks;
@property (nonatomic, copy) NSArray *items;

- (instancetype)initWithModel:(CourseModel *)model;
- (void)saveToCourseTable;
- (void)removeFromCourseTable;
@end
