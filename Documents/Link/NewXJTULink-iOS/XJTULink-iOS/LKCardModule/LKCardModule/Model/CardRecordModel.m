//
//  CardRecordModel.m
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CardRecordModel.h"
#import "MTLValueTransformer+LKModel.h"
RefreshMode LKCardRefreshModeMake(LKRefreshType type,NSInteger index) {
    RefreshMode mode = {type,index};
    return mode;
};

@interface CardRecordModel()
@property (nonatomic, strong) CardRecordModel *model;
@end
@implementation CardRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postId":@"id",
             @"time":@"time",
             @"locale":@"store",
             @"amount":@"trade_count",
             };
}

+ (NSValueTransformer *)amountJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}
- (instancetype)initWithModel:(CardRecordModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self setupRACWithModel:model];
    }
    return self;
}

- (void)setupRACWithModel:(CardRecordModel *)model {
    RAC(self, postId) = RACObserve(model, postId);
    RAC(self, time) = RACObserve(model, time);
    RAC(self, locale) = RACObserve(model, locale);
    RAC(self, amount) = RACObserve(model, amount);
    RAC(self, weekday) = RACObserve(model, weekday);
}

- (NSString *)time {
    if ([_time length] >= 5) {
        _time = [_time substringToIndex:5];
    }
    return _time;
}
@end
