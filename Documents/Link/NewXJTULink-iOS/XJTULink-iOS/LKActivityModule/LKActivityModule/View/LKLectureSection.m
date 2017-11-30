//
//  LKLectureSection.m
//  LKActivityModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLectureSection.h"
#import "LKWebBrowser.H"
#import "LectureListViewModel.h"
#import "Constants.h"
@interface LKLectureSection()
@property (nonatomic, strong) LectureListViewModel *viewModel;
@end
@implementation LKLectureSection
- (instancetype)init {
    self = [super init];
    if (self) {
        RAC(self,viewModels) =
        [[RACObserve(self.viewModel, lectureItemViewModels) filter:^BOOL(id value) {
            return value != nil;
        }] map:^id(NSArray *value) {
            return @[value[arc4random() % value.count]];
        }];
        
        @weakify(self);
        [[RACSignal merge:@[[self.viewModel.networkingRAC executionSignal],
                            [self.viewModel.networkingRAC requestErrorSignal]
                            ]] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"[LKLectureSection] did load.");
            self.loaded = YES;
        }];
        
        [self.viewModel.networkingRAC.refreshCommand execute:nil];
    }
    return self;
}

#pragma mark - override
- (NSString *)title {
    return @"讲座预告";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"LectureItemCell":@"LectureItemViewModel"
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    LectureItemViewModel *viewModel = self.viewModels[rowIndex];
    return [LKWebBrowser webBrowserWithURL:viewModel.url title:@"讲座信息"];
}

- (void)setNeedUpdate {
//    self.loaded = NO;
//    [self.viewModel.networkingRAC.refreshCommand execute:nil];
}

#pragma mark - getter
- (LectureListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LectureListViewModel alloc] initWithPageSize:5];
    }
    return _viewModel;
}
@end
