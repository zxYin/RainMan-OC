//
//  CourseTableViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseTableViewModel.h"
#import "WeekManager.h"
#import "CourseManager.h"
#import "Foundation+LKCourse.h"
#import "CourseTableAPIManager.h"
#import "NSDate+LKTools.h"
#import <BlocksKit.h>
@interface CourseTableViewModel()
@property (nonatomic, assign) NSInteger originalWeek;
@end

@implementation CourseTableViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (instancetype)initWithWeek:(NSInteger)week {
    self = [super init];
    if (self) {
        self.week = week;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    CourseManager *manager = [CourseManager sharedInstance];
    @weakify(self);
    RAC(self, originalWeek) = RACObserve([WeekManager sharedInstance], week);
    [[RACSignal merge:@[RACObserve(self, week),
                        RACObserve(manager, courseTable)]]
      subscribeNext:^(id x) {
          @strongify(self);
          NSMutableArray *courseViewModels = [NSMutableArray new];
          [manager.courseTable enumerateObjectsUsingBlock:^(NSArray *models, NSUInteger idx, BOOL * _Nonnull stop) {
              
              __block CourseModel *lastCourseModel = nil;
              [models enumerateObjectsUsingBlock:^(CourseModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
                  NSLog(@"curr:%@",model);
                  NSLog(@"last:%@",lastCourseModel);
                  if (LKRangeIntersects(model.timeRange, lastCourseModel.timeRange)) {
                      BOOL isCurrIn = [model.weekFormatter.indexSet containsIndex:self.week];
                      BOOL isLastIn = [lastCourseModel.weekFormatter.indexSet containsIndex:self.week];
                      
                      if (isCurrIn && !isLastIn) {
                          NSLog(@"移除:%@ 添加:%@",lastCourseModel,model);
                          // 移除上一个 并添加新的
                          [courseViewModels removeLastObject];
                          [courseViewModels addObject:[[CourseViewModel alloc] initWithModel:model]];
                      }
                      
                      // 这里如果课表内存储有冲突的话，这里会有问题
                      
                  } else {
                      [courseViewModels addObject:[[CourseViewModel alloc] initWithModel:model]];
                  }
                  lastCourseModel = model;
              }];
          }];
          
          NSLog(@".. %@", [courseViewModels copy]);
          self.courseViewModels = [courseViewModels copy];
      }];
    
    
    
    [RACObserve(self, week) subscribeNext:^(id x) {
        @strongify(self);
        NSDate *date = [NSDate date];
        NSInteger offset = (self.week - [WeekManager sharedInstance].week) * 7;
        if (offset>0) {
            date = [date dateByAddingDays:offset];
        } else {
            date = [date dateBySubtractingDays:labs(offset)];
        }
        
        self.daysOfWeek =
        [[NSDate datesOfWeekForDate:date]
         bk_map:^id(NSDate *date) {
             return [date formattedDateWithFormat:@"dd"];
         }];
    }];
    

}

- (BOOL)isCurrentWeek {
    return (self.week == [WeekManager sharedInstance].week);
}

- (void)resetWeek {
    self.week = [WeekManager sharedInstance].week;
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return [[CourseManager sharedInstance] networkingRAC];
}

- (BOOL)isExpired:(CourseViewModel *)viewModel {
    return ![viewModel.model.weekFormatter.indexSet containsIndex:self.week];
}

#pragma mark - getter

@end
