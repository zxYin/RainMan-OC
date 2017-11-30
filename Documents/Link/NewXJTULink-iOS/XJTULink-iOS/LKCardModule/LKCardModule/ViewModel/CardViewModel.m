//
//  LKCardViewModel.m
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CardViewModel.h"
#import "CardModel.h"
#import "BalanceAPIManager.h"
#import "ConsumeListAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
#import "AppContext.h"
#import <BlocksKit/BlocksKit.h>
NSString * const kNetworkingRACTypeBalance = @"kNetworkingRACTypeBalance";
NSString * const kNetworkingRACTypeCardRecord = @"kNetworkingRACTypeCardRecord";

@interface CardViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) YLNetworkingRACTable *networkingRACs;
@property (nonatomic, strong) YLBaseAPIManager *balanceAPIManager;
@property (nonatomic, strong) YLPageAPIManager *cardRecordAPIManager;

@end
@implementation CardViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _balance = @"0.00";
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    
    [self.balanceAPIManager.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        CardModel *model = [self.balanceAPIManager fetchDataFromModel:[CardModel class]];
        CGFloat count = [model.balance floatValue] + [model.transitionBalance floatValue];
        self.balance = [NSString stringWithFormat:@"%.2f",count];
    }];
    
    [self.cardRecordAPIManager.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *cardRecordViewModels = [x boolValue]?[NSMutableArray array]:[NSMutableArray arrayWithArray:self.cardRecordViewModels];
        NSMutableArray *cardRecordModels = [self.cardRecordAPIManager fetchDataFromModel:[CardRecordModel class]];
        
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
        [calendar setTimeZone: timeZone];
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        [formatter setTimeZone:timeZone];
        for (int i=0; i<cardRecordModels.count; i++) {
            CardRecordModel *myCardRecordModel = cardRecordModels[i];
            if (myCardRecordModel) {
                NSString *dateString = myCardRecordModel.time;
                NSDate *date = [formatter dateFromString:dateString];
                NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
                myCardRecordModel.weekday = [weekdays objectAtIndex:theComponents.weekday];
                myCardRecordModel.time = [dateString substringToIndex:10];
            }
            cardRecordModels[i] = myCardRecordModel;
        }
        [cardRecordViewModels addObjectsFromArray:[cardRecordModels bk_map:^id(CardRecordModel *obj) {
            return [[CardRecordViewModel alloc] initWithModel:obj];
        }]];
        NSLog(@"cardRecordViewModels : ==>%@",self.cardRecordViewModels);
        self.cardRecordViewModels = [cardRecordViewModels copy];
        self.refreshMode = LKCardRefreshModeMake(LKRefreshTypeDefault, 0);
        self.needEndRefresh = YES;
    }];
    
     [[RACSignal merge:@[self.balanceAPIManager.requestErrorSignal,
                         self.cardRecordAPIManager.requestErrorSignal]]
      subscribeNext:^(YLResponseError *error) {
          [AppContext showError:error.message];
     }];
}

- (BOOL)hasNextPage {
    return self.cardRecordAPIManager.hasNextPage;
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    return params;
}

- (YLNetworkingRACTable *)networkingRACs {
    if (_networkingRACs == nil) {
        _networkingRACs = [YLNetworkingRACTable strongToWeakObjectsMapTable];
        _networkingRACs[kNetworkingRACTypeBalance] = self.balanceAPIManager;
        _networkingRACs[kNetworkingRACTypeCardRecord] = self.cardRecordAPIManager;
    }
    return _networkingRACs;
}


#pragma mark - getter
- (YLBaseAPIManager *)balanceAPIManager {
    if(_balanceAPIManager == nil) {
        _balanceAPIManager = [[BalanceAPIManager alloc] init];
    }
    return _balanceAPIManager;
}

- (YLBaseAPIManager *)cardRecordAPIManager {
    if (_cardRecordAPIManager == nil) {
        _cardRecordAPIManager = [ConsumeListAPIManager apiManagerWithType:ConsumeTypeCustom];
        _cardRecordAPIManager.dataSource = self;
    }
    return _cardRecordAPIManager;
}


@end
