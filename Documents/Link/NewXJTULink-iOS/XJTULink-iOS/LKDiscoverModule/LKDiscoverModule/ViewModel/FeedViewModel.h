//
//  FeedViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleURLModel.h"
#import "ClubModel.h"
#import "HeadlineModel.h"
#import "LKNetworking.h"
#import "SpecialColumnModel.h"
#import "ClubViewModel.h"
#import "CommunityContext.h"

@interface FeedViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSString *searchText;
@property (nonatomic, copy, readonly) NSArray<HeadlineModel *> *headlineModels;

@property (nonatomic, copy, readonly) SpecialColumnModel *specialColumnModel;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *clubTypes;

@property (nonatomic, strong, readonly) ClubViewModel *hottestClubViewModel;

@property (nonatomic, copy) NSArray<CommunityContext *> *communityContexts;

@property (nonatomic, assign) BOOL needReload;
@end
