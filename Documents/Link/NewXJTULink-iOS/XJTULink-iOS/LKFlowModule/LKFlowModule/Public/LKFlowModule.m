//
//  LKFlowModule.m
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKFlowModule.h"
#import "FlowModel.h"
#import "FlowAPIManager.h"
#import "Foundation+LKFlowExtension.h"
#import "FlowViewController.h"
#import "User.h"
@implementation LKFlowModule

@end

@implementation LKFlowService
AUTH_REQUIRE(@"LKFlow_flowViewController")


- (BOOL)isEnable {
    return YES;
}

- (RACSignal *)LKFlow_flowStringSignal:(NSDictionary *)params {
    [[LKServicePool sharedInstance] registerService:self];
    FlowAPIManager *apiManager = [FlowAPIManager new];
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@"0.00"]; // 默认值
        @strongify(self);
        [[apiManager.executionSignal map:^id(id value) {
            FlowModel *model = [apiManager fetchDataFromModel:[FlowModel class]];
            CGFloat flow = [NSString calculateFlowCountWithInFlow:model.inFlow outFlow:model.outFlow];
            return [NSString stringWithFormat:@"%.2f", flow];
        }] subscribeNext:^(id x) {
            NSLog(@"成功执行，下一步:%@",x);
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        [apiManager.requestErrorSignal subscribeNext:^(id x) {
            NSLog(@"获取流量失败:%@",x);
            [subscriber sendError:x];
        }];
        [apiManager.requestCommand execute:nil];
        return [RACDisposable disposableWithBlock:^{
            [[LKServicePool sharedInstance] removeService:self];
            
            NSLog(@"取消订阅流量");
        }];
    }];
}

- (UIViewController *)LKFlow_flowViewController:(NSDictionary *)params {
    return [[FlowViewController alloc] init];
}
@end
