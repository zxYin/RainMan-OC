//
//  FeedModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HeadlineModel.h"
#import "ClubModel.h"
#import "SingleURLModel.h"

#import "SpecialColumnModel.h"
#import "CommunityContext.h"

@interface FeedModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSArray<HeadlineModel *> *headlineModels;
@property (nonatomic, copy) SpecialColumnModel *specialColumnModel;
@property (nonatomic, copy) ClubModel *hottestClubModel;

@property (nonatomic, copy) NSArray<CommunityContext *> *communityContexts;
@end
