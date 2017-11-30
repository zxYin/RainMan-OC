//
//  LKCardViewModel.h
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "CardRecordModel.h"
extern NSString * const kNetworkingRACTypeBalance;
extern NSString * const kNetworkingRACTypeCardRecord;


@interface CardViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, strong) NSArray<CardRecordViewModel *> *cardRecordViewModels;
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, assign) RefreshMode refreshMode;
@property (nonatomic, assign) BOOL needEndRefresh;
@property (nonatomic, strong) NSString *balance;
@end
