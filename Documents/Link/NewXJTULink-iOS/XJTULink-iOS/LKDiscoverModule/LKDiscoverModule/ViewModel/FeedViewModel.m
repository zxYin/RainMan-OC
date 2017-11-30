//
//  FeedViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FeedViewModel.h"
#import <BlocksKit/BlocksKit.h>
#import "FeedModel.h"
#import "FeedAPIManager.h"
@interface FeedViewModel()
@property (nonatomic, strong) FeedAPIManager *feedAPIManager;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSArray<HeadlineModel *> *headlineModels;
@property (nonatomic, copy) SpecialColumnModel *specialColumnModel;
@property (nonatomic, copy) NSArray<NSDictionary *> *clubTypes;

@property (nonatomic, strong) ClubViewModel *hottestClubViewModel;
@end

@implementation FeedViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.needReload = NO;
        [self setupData];
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        FeedModel *model = [self.feedAPIManager fetchDataFromModel:FeedModel.class];
        self.searchText = model.searchText;
        self.headlineModels = model.headlineModels;
        self.specialColumnModel = model.specialColumnModel;
        self.hottestClubViewModel =
        [[ClubViewModel alloc] initWithClubModel:model.hottestClubModel];
        self.communityContexts = model.communityContexts;
        self.needReload = YES;
    }];
}

- (void)setupData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ClubTypes" ofType:@"plist"];
    NSArray *clubTypes = [NSArray arrayWithContentsOfFile:path];
    
    self.clubTypes =
    [[clubTypes subarrayWithRange:NSMakeRange(1, clubTypes.count - 1)]
     bk_map:^id(NSDictionary *type) {
         return @{
                  kClubTypeKeyImage:[UIImage imageNamed:type[@"image"]],
                  kClubTypeKeyTitle:type[@"title"],
                  kClubTypeKeyId:type[@"id"],
                  };
    }];
    
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.feedAPIManager;
}

#pragma mark - getter
- (FeedAPIManager *)feedAPIManager {
    if(_feedAPIManager == nil) {
        _feedAPIManager = [[FeedAPIManager alloc] init];
    }
    return _feedAPIManager;
}
@end
