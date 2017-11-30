//
//  CardModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CardModel.h"
#import "Foundation+LKTools.h"
@interface CardModel()
@property (nonatomic, copy) NSString *blockingStatus;
@property (nonatomic, copy) NSString *lossStatus;
@end

@implementation CardModel
@dynamic status;
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"balance":@"balance",
            @"transitionBalance":@"transition_balance",
            @"blockingStatus":@"blocking_status",
            @"lossStatus":@"loss_status",
             };
}


+ (NSValueTransformer *)balanceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

- (NSString *)status {
    NSString *status = @"正常";
    if ([NSString notBlank:self.blockingStatus]
        && ![self.blockingStatus containsString:@"正常"]) {
        status = self.blockingStatus;
    }
    if ([NSString notBlank:self.lossStatus]
        && ![self.lossStatus containsString:@"正常"]) {
        status = self.lossStatus;
    }
    return status;
}
@end
