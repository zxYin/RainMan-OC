//
//  AccessoryListViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AccessoryListViewModel.h"
#import "AccessoryAPIManager.h"

@interface AccessoryListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSArray<AccessoryModel *> *accessoryModels;
@property (nonatomic, strong) AccessoryAPIManager *accessoryAPIManager;
@end

@implementation AccessoryListViewModel
- (instancetype)initWithNewsId:(NSString *)newsId {
    self = [super init];
    if (self) {
        self.newsId = newsId;
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        self.accessoryModels = [self.accessoryAPIManager fetchDataFromModel:AccessoryModel.class];
    }];
}



- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.accessoryAPIManager) {
        params = @{
                   kAccessoryAPIManagerParamsKeyNewsId:self.newsId,
                   };
    }
    return params;
}

- (NSString *)newsId {
    return _newsId?:@"";
}

- (AccessoryAPIManager *)accessoryAPIManager {
    if (_accessoryAPIManager == nil) {
        _accessoryAPIManager = [AccessoryAPIManager new];
        _accessoryAPIManager.dataSource = self;
    }
    return _accessoryAPIManager;
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.accessoryAPIManager;
}


- (NSMutableDictionary *)downloadedFiles {
    if (_downloadedFiles == nil) {
        _downloadedFiles = [[NSMutableDictionary alloc] init];
    }
    return _downloadedFiles;
}


- (BOOL)fileExistsByName:(NSString *)fileName {
    static NSString *basePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
        basePath = [documentPaths firstObject];
    });
    
    NSString *filePath = [basePath stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
