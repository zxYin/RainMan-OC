//
//  LectureListViewModel.m
//  LKActivityModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureListViewModel.h"
#import "LectureListAPIManager.h"
@interface LectureListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) LectureListAPIManager *lectureAPIManager;
@end
@implementation LectureListViewModel
- (instancetype)init {
    return [self initWithPageSize:20];
}


- (instancetype)initWithPageSize:(NSInteger)pageSize {
    self = [super init];
    if (self) {
        self.pageSize = pageSize;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        NSLog(@"网络访问完毕");
        @strongify(self);
        NSMutableArray *lectureItemViewModels = [x boolValue]?[NSMutableArray array]:[NSMutableArray arrayWithArray:self.lectureItemViewModels];
        
        NSArray *lectureModels = [self.lectureAPIManager fetchDataFromModel:LectureModel.class];
        RACSequence *lectureItemViewModelsSeq = [lectureModels.rac_sequence map:^id(LectureModel *model) {
            return [[LectureItemViewModel alloc] initWithModel:model];
        }];
        [lectureItemViewModels addObjectsFromArray:lectureItemViewModelsSeq.array];
        self.lectureItemViewModels = [lectureItemViewModels copy];
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    return params;
}

#pragma mark - getter && setter

- (LectureListAPIManager *)lectureAPIManager {
    if (_lectureAPIManager == nil) {
        _lectureAPIManager = [[LectureListAPIManager alloc] initWithPageSize:self.pageSize];
        _lectureAPIManager.dataSource = self;
    }
    return _lectureAPIManager;
}


- (BOOL)hasNextPage {
    return self.lectureAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.lectureAPIManager;
}
@end
