//
//  LibrarySection.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibrarySection.h"
#import "LibraryViewModel.h"
#import "LibraryViewController.h"
@interface LibrarySection()
@property (nonatomic, strong) LibraryViewModel *viewModel;
@end
@implementation LibrarySection
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
    [RACObserve(self.viewModel, libBookViewModels)
     subscribeNext:^(NSArray<LibBookViewModel *> *viewModels) {
         @strongify(self);
         NSMutableArray *visibleViewModels = [[NSMutableArray alloc] init];
         [viewModels enumerateObjectsUsingBlock:^(LibBookViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.countdown integerValue] < 7) {
                 [visibleViewModels addObject:obj];
             }
         }];
         
         if (visibleViewModels.count != 0) {
             self.viewModels = [visibleViewModels copy];
             self.hidden = NO;
         }
    }];
    
    
    
    [[RACSignal merge:@[[self.viewModel.networkingRAC executionSignal],
                        [self.viewModel.networkingRAC requestErrorSignal]
                        ]] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"[LibrarySection] did Load.");
        self.loaded = YES;
    }];
}

- (void)configCell:(UITableViewCell *)cell forRowIndex:(NSInteger)rowIndex {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
//    cell.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (NSString *)title {
    return @"借阅信息";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"LibBookItemCell":@"LibBookViewModel"
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return [[LibraryViewController alloc] init];
}

- (void)setNeedUpdate {
    self.loaded = //[[self.viewModel.networkingRAC requestCommand] execute:nil];
    ![self.viewModel.networkingRAC.requestCommand tryExecuteIntervalLongerThan: 60 * 60];
}

#pragma mark - getter
- (LibraryViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [LibraryViewModel new];
    }
    return _viewModel;
}
@end
