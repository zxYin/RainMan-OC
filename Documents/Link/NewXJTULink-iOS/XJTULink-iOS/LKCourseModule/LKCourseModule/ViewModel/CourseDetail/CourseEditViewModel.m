//
//  CourseEditViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseEditViewModel.h"
#import "Foundation+LKCourse.h"
#import "Foundation+LKTools.h"
#import <ReactiveCocoa.h>
#import "CourseManager.h"
@import UIKit.UIImage;

NSString * const kCourseEditItemKeyEditable = @"kCourseEditItemKeyEditable";
NSString * const kCourseEditItemKeyIcon = @"kCourseEditItemKeyIcon";
NSString * const kCourseEditItemKeyValue = @"kCourseEditItemKeyValue";
NSString * const kCourseEditItemKeyPlaceholder = @"kCourseEditItemKeyPlaceholder";

@interface CourseEditViewModel()
@property (nonatomic, strong) CourseModel *originalModel;
@property (nonatomic, assign) BOOL isNew;
@end

@implementation CourseEditViewModel
- (instancetype)initWithModel:(CourseModel *)model {
    self = [super init];
    if (self) {
        if (model != nil) {
            self.originalModel = model;
            self.model = [model copy];
            self.isNew = NO;
        } else {
            self.model = [[CourseModel alloc] init];
            self.isNew = YES;
        }
        
        @weakify(self);
        
        RAC(self,time) =
        [[RACSignal merge:@[RACObserve(self.model, weekday),
                            RACObserve(self.model, timeRange)]]
         map:^id(id value) {
             @strongify(self);
             return [NSString stringWithFormat:@"%@ %@节",
                     [NSString stringForWeekday:self.model.weekday],
                     LKTimeFromRange(self.model.timeRange)];
         }];
        
        RAC(self, weeks) =
        [RACObserve(self.model, weekFormatter) map:^id(id x) {
            @strongify(self);
            return [NSString stringWithFormat:@"%@周",
                    self.model.weekFormatter.groupedString];
        }];
        
    }
    return self;
}


- (BOOL)isConflict {
    return [[CourseManager sharedInstance] isConflict:self.model];
}

- (void)saveToCourseTable {
    CourseManager *manager = [CourseManager sharedInstance];
    if (self.originalModel) {
        /*
         * 这里先删除，再添加，防止切换星期以及更新顺序，统一逻辑
         */
        [manager removeCourseWithUUID:self.originalModel.uuid];
        [self.originalModel updateFromModel:self.model];
        [manager addCourseModel:self.originalModel];
    } else {
        [manager addCourseModel:self.model];
    }
}
- (void)removeFromCourseTable {
    [[CourseManager sharedInstance] removeCourseWithUUID:self.originalModel.uuid];
}


@end
