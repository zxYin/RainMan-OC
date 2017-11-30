//
//  ToolsItemViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ToolsItemViewModel.h"
#import "AppMediator+LKFlowModule.h"
#import "AppMediator+LKCardModule.h"

@implementation ToolsItemViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.balance = @"0.00";
        self.flow = @"0.00";
        [self.rac_setNeedUpdateCommand execute:nil];
    }
    return self;
}

- (RACCommand *)rac_setNeedUpdateCommand {
    if (_rac_setNeedUpdateCommand == nil) {
        @weakify(self);
        _rac_setNeedUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            AppMediator *mediator = [AppMediator sharedInstance];
            
            RACSignal *balanceStringSignal = [mediator LKCard_balanceStringSignal];
            RACSignal *flowStringSignal = [mediator LKFlow_flowStringSignal];
            
            [balanceStringSignal subscribeNext:^(id x) {
                self.balance = x;
            }];
            
            [flowStringSignal subscribeNext:^(id x) {
                self.flow = x;
            }];
            
            return [RACSignal empty];
        }];
    }
    return _rac_setNeedUpdateCommand;
}


@end
