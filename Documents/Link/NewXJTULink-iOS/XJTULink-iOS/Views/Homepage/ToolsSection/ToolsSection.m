//
//  ToolsSection.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ToolsSection.h"
#import "ToolsViewCell.h"
#import "ToolsItemViewModel.h"

#import "AppMediator+LKFlowModule.h"
#import "AppMediator+LKCardModule.h"
@interface ToolsSection()
@property (nonatomic, strong) ToolsItemViewModel *viewModel;
@end

@implementation ToolsSection
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {    
    self.viewModels = @[self.viewModel];
    self.loaded = YES;
}

#pragma mark - override
- (NSString *)title {
    return @"生活管家";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"ToolsViewCell":@"ToolsItemViewModel"
             };
}

- (void)configCell:(ToolsViewCell *)cell forRowIndex:(NSInteger)rowIndex {
    NSLog(@"configCell:%@",cell);
    [cell setRightButtonEvent:^(ToolsViewCell *cell) {
       [[AppMediator sharedInstance] LKCard_cardViewController:^(UIViewController *cardViewController) {
           cardViewController.hidesBottomBarWhenPushed = YES;
           [[[AppContext sharedInstance] navigationControllerOfTabBarControllerAtItem:LKTabBarItemHomePage] pushViewController:cardViewController animated:YES];
       }];
    }];
    
    [cell setLeftButtonEvent:^(ToolsViewCell *cell) {
        [[AppMediator sharedInstance] LKFlow_flowViewController:^(UIViewController *flowViewController) {
            flowViewController.hidesBottomBarWhenPushed = YES;
            [[[AppContext sharedInstance] navigationControllerOfTabBarControllerAtItem:LKTabBarItemHomePage] pushViewController:flowViewController animated:YES];
        }];
    }];
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return nil;
}

- (void)setNeedUpdate {
    [self.viewModel.rac_setNeedUpdateCommand execute:nil];
}


#pragma mark - getter
- (ToolsItemViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ToolsItemViewModel alloc] init];
    }
    return _viewModel;
}
@end
