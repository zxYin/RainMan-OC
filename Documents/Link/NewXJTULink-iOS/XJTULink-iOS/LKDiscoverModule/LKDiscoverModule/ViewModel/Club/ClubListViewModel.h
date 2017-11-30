//
//  ClubListViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "ClubViewModel.h"

@interface ClubListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, assign, readonly) BOOL hasNextPage;

@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *clubTypes;
@property (nonatomic, copy) NSString *currentTypeId;

@property (nonatomic, copy) NSArray<ClubViewModel *> *clubViewModels;

- (instancetype)initWithInitialTypeId:(NSString *)typeId;
@end
