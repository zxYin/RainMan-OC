//
//  FlowViewModel.m
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FlowViewModel.h"
#import "FlowModel.h"
#import "FlowAPIManager.h"
#import "DateTools.h"
#import "Foundation+LKTools.h"
#import "Foundation+LKFlowExtension.h"

@interface FlowViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) FlowAPIManager *flowAPIManager;
@property (nonatomic, copy) NSArray *itemValues;

@property (strong, nonatomic) NSArray *timeTitles;
@property (strong, nonatomic) NSArray *flowHistory;
@end
@implementation FlowViewModel

- (instancetype)init {
    self = [super init];
    if(self) {
        _itemTitles = @[@"IP", @"入流量", @"出流量", @"费用", @"状态"];
        _itemValues = @[@"0.0.0.0",@"0 GB",@"0 GB",@"暂无信息",@"正常"];
        
        NSMutableArray *xLabels = [NSMutableArray arrayWithCapacity:12];
        for (NSUInteger i=0; i<6; i++) {
            NSUInteger month = ([[NSDate date] month] - i + 12) % 12 + 1;
            [xLabels insertObject:[NSString stringWithFormat:@"%td 月",month] atIndex:0];
        }
        _timeTitles = [xLabels copy];
        _flowHistory = @[@0,@0,@0,@0,@0,@0];
        
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        FlowModel *model = [self.flowAPIManager fetchDataFromModel:FlowModel.class];
        NSString *charge = [NSString isBlank:model.charge]?model.charge:@"0";
        self.itemValues = [NSArray arrayWithObjects:model.ip?:@"",model.inFlow?:@"",model.outFlow?:@"",
                           charge,model.status?:@"",nil];;
        
        NSMutableArray *flowHistory = [NSMutableArray arrayWithCapacity:12];
        NSMutableArray *months = [NSMutableArray arrayWithCapacity:12];
        for (FlowHistoryItemModel *item in [model.historyItemModels reverseObjectEnumerator]) {
            CGFloat flow =[NSString calculateFlowCountWithInFlow:item.inFlow outFlow:item.outFlow];

            [flowHistory insertObject:@(flow) atIndex:0];
            
            
            NSRange range = [item.time rangeOfString:@"年"];
            if (range.location != NSNotFound) {
                [months insertObject:[item.time substringFromIndex:range.location+1] atIndex:0];
            } else {
                [months insertObject:item.time atIndex:0];
            }
            
            if (flowHistory.count >= 6) {
                break;
            }
        }
        self.timeTitles = months;
        self.flowHistory = flowHistory;
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.flowAPIManager) {
        params = @{
                   kFlowAPIManagerParamsKeyIsDetail:@(YES)
                   };
    }
    return params;
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.flowAPIManager;
}

- (FlowAPIManager *)flowAPIManager {
    if (_flowAPIManager == nil) {
        _flowAPIManager = [FlowAPIManager new];
        _flowAPIManager.dataSource = self;
    }
    return _flowAPIManager;
}


@end
