//
//  CourseAdViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseAdViewModel.h"
#import "CourseManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Foundation+LKCourse.h"
#import "NSDate+LKTools.h"
#import <BlocksKit/BlocksKit.h>
#import "WeekManager.h"

@interface CourseAdViewModel()
@property (nonatomic, copy) NSArray<CourseViewModel *> *courseViewModels;
@end
@implementation CourseAdViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    CourseManager *manager = [CourseManager sharedInstance];
    @weakify(self);
    [RACObserve(manager, courseTable)
     subscribeNext:^(NSArray<NSArray<CourseModel *> *> *courseTable) {
         @strongify(self);
         NSInteger weekday = [[NSDate date] weekdayAbsolute];
         NSMutableArray *courseViewModels = [NSMutableArray array];
         [courseTable[weekday] enumerateObjectsUsingBlock:^(CourseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.weekFormatter.indexSet containsIndex:[WeekManager sharedInstance].week]) {
                 [courseViewModels addObject:[[CourseViewModel alloc]initWithModel:obj]];
             }
         }];
         self.courseViewModels = [courseViewModels copy];
     }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    CourseManager *manager = [CourseManager sharedInstance];
    return manager.isLoaded?nil:manager.networkingRAC;
}

@end
