//
//  ActivityListViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "ActivityModel.h"
@interface ActivityListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, copy) NSArray<ActivityModel *> *activityModels;

- (instancetype)initWithClubId:(NSString *)clubId;
@end
