//
//  ScheduleSection.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/16.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleSection.h"
#import "ScheduleListViewModel.h"
#import "ScheduleViewController.h"
#import "ScheduleManager.h"
#import <BlocksKit/BlocksKit.h>

@interface ScheduleSection()
@property (nonatomic, strong) ScheduleListViewModel *viewModel;
@end
@implementation ScheduleSection
#pragma mark - override

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.hidden = YES;
    @weakify(self);
    ScheduleManager *manager = [ScheduleManager sharedInstance];
    [RACObserve(manager, scheduleModels)
     subscribeNext:^(NSArray<ScheduleItemViewModel *> *viewModels) {
         @strongify(self);
         NSArray *scheduleModels = manager.scheduleModels;
         NSArray *newScheduleItemViewModels = [scheduleModels bk_map:^id(ScheduleModel * obj) {
             return [[ScheduleItemViewModel alloc] initWithModel:obj];
         }];

         NSMutableArray *visibleViewModels = [[NSMutableArray alloc] init];
         [newScheduleItemViewModels enumerateObjectsUsingBlock:^(ScheduleItemViewModel *viewModel, NSUInteger idx, BOOL * _Nonnull stop) {
             if (!viewModel.isEnd
                 && viewModel.leftDay < 7) {
                 [visibleViewModels addObject:viewModel];
             }
         }];
         
         if (visibleViewModels.count != 0) {
             self.viewModels = [visibleViewModels copy];
             self.hidden = NO;
         } else {
             self.hidden = YES;
         }
     }];
    
    [[RACSignal merge:@[[self.viewModel.networkingRAC executionSignal],
                        [self.viewModel.networkingRAC requestErrorSignal]
                        ]] subscribeNext:^(id x) {
        @strongify(self);
        self.loaded = YES;
    }];
}

- (void)configCell:(UITableViewCell *)cell forRowIndex:(NSInteger)rowIndex {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString *)title {
    return @"考试安排";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"ScheduleItemCell":@"ScheduleItemViewModel"
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return [[ScheduleViewController alloc] init];
}

- (void)setNeedUpdate {
    self.loaded = ![self.viewModel.networkingRAC.requestCommand tryExecuteIntervalLongerThan: 60 * 60];
}

#pragma mark - getter
- (ScheduleListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [ScheduleListViewModel new];
    }
    return _viewModel;
}

@end
