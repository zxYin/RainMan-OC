//
//  LKCardModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKCardModule.h"
#import "CardModel.h"
#import "BalanceAPIManager.h"
#import "TransferViewController.h"
#import "CardViewController.h"
#import "User.h"
@implementation LKCardModule

@end

@implementation LKCardService
AUTH_REQUIRE(@"LKCard_cardViewController",@"LKCard_transferViewController")

- (RACSignal *)LKCard_balanceStringSignal:(NSDictionary *)params {
    [[LKServicePool sharedInstance] registerService:self];
    BalanceAPIManager *apiManager = [BalanceAPIManager new];
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[apiManager.executionSignal map:^id(id value) {
            CardModel *model = [apiManager fetchDataFromModel:[CardModel class]];
            NSLog(@"%@",model.status);
            CGFloat count = [model.balance floatValue] + [model.transitionBalance floatValue];
            return [NSString stringWithFormat:@"%.2f",count];
        }] subscribeNext:^(id x) {
            [[LKServicePool sharedInstance] removeService:self];
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        [apiManager.requestErrorSignal subscribeNext:^(id x) {
            [[LKServicePool sharedInstance] removeService:self];
            [subscriber sendError:x];
//            [subscriber sendCompleted];
        }];
        [apiManager.requestCommand execute:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅余额");
        }];
    }];
}

- (UIViewController *)LKCard_cardViewController:(NSDictionary *)params {
    return [[CardViewController alloc] init];
}
- (UIViewController *)LKCard_transferViewController:(NSDictionary *)params {
    return [[TransferViewController alloc] init];
}
@end
