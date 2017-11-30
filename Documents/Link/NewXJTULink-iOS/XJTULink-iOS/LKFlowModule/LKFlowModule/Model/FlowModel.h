//
//  FlowModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/24.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface FlowHistoryItemModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *inFlow;
@property (nonatomic, copy) NSString *outFlow;
@property (nonatomic, copy) NSString *charge;
@end

@interface FlowModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *inFlow;
@property (nonatomic, copy) NSString *outFlow;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *charge;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSArray<FlowHistoryItemModel *> *historyItemModels;
@end
