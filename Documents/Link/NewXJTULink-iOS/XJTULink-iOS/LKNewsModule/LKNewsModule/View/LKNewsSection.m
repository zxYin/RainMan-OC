//
//  LKNewsSection.m
//  LKNewsModule
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNewsSection.h"
#import "ViewsConfig.h"
#import "LKNewsBrowser.h"
#import "NewsListViewModel.h"
@interface LKNewsSection()
@property (nonatomic, strong) NewsListViewModel *viewModel;
@end
@implementation LKNewsSection
- (instancetype)init {
    self = [super init];
    if (self) {
        RAC(self,viewModels) = RACObserve(self.viewModel, newsItemViewModels);
        @weakify(self);
        [[RACSignal merge:@[[self.viewModel.networkingRAC executionSignal],
                            [self.viewModel.networkingRAC requestErrorSignal]
                            ]] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"[LKNewsSection] did Load.");
            self.loaded = YES;
        }];
        
        [[self.viewModel.networkingRAC requestErrorSignal] subscribeNext:^(id x) {
            NSLog(@"self.viewModel.networkingRAC requestErrorSignal:%@",x);
            [[self.viewModel.networkingRAC refreshCommand] yl_setTimestamp:0];
        }];
        
        [self.viewModel.networkingRAC.refreshCommand execute:nil];
    }
    return self;
}

#pragma mark - override
- (NSString *)title {
    return @"新闻速递";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"NewsViewCell":@"NewsItemViewModel"
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return [[LKNewsBrowser alloc] initWithViewModel:self.viewModels[rowIndex]];
}

- (void)setNeedUpdate {
//    [self.viewModel.networkingRAC.refreshCommand execute:nil];
    self.loaded =
    ![self.viewModel.networkingRAC.refreshCommand tryExecuteIntervalLongerThan:30 * 60];
}

#pragma mark - getter
- (NewsListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[NewsListViewModel alloc] initWithTyes:nil sources:nil pageSize:4];
    }
    return _viewModel;
}
@end
