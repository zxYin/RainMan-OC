//
//  LKLikeManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKLikeManager.h"
#import <libkern/OSAtomic.h>
#import "Foundation+LKTools.h"
#import "LikeAPIManager.h"

NSString * const kLKLikeItemTypeConfession = @"confession_id";
NSString * const kLKLikeItemTypeConfessionComment = @"comment_id";


static NSString * const kLKLikeManagerItemKeyId = @"kLKLikeManagerItemKeyId";
static NSString * const kLKLikeManagerItemKeyType = @"kLKLikeManagerItemKeyType";
static NSString * const kLKLikeManagerItemKeyIsCancel = @"kLKLikeManagerItemKeyIsCancel";
static NSString * const kLKLikeManagerItemKeyTryCount = @"kLKLikeManagerItemKeyTryCount";

static NSInteger maxLikeManagerCount = 5;
static NSInteger maxRetryCount = 10;


static OSSpinLock lk_like_manager_lock = OS_SPINLOCK_INIT;
@interface LKLikeManager()<YLAPIManagerDataSource, YLAPIManagerDelegate>
@property (nonatomic, strong) NSMutableSet<LikeAPIManager *> *likeManagers;
@property (nonatomic, strong) NSMutableSet<LikeAPIManager *> *loadingLikeManagers;

@property (nonatomic, strong) NSMutableDictionary *toLikeItems;
@end
@implementation LKLikeManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKLikeManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKLikeManager alloc] init];
    });
    return instance;
}

- (void)likeItemId:(NSString *)itemId type:(NSString *)type isCancel:(BOOL)isCancel {
    [self registerItemId:itemId type:type isCancel:isCancel];
}

#pragma mark -
- (NSDictionary *)paramsForAPI:(LikeAPIManager *)apiManager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDictionary *item = [self fetchAnyItem];
    if(item) {
        apiManager.item = item;
        params[item[kLKLikeManagerItemKeyType]] = item[kLKLikeManagerItemKeyId];
        params[@"is_cancel"] = item[kLKLikeManagerItemKeyIsCancel];
    }
    return [params copy];
}
    
- (void)apiManagerLoadDataSuccess:(LikeAPIManager *)apiManager {
    [self handleAPIManger:apiManager];
}

- (void)apiManager:(LikeAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    NSDictionary *item = apiManager.item;
    if (item &&
        [item[kLKLikeManagerItemKeyTryCount] integerValue] < maxRetryCount) {
        // 如果失败，60秒重试一次，maxRetryCount次之后放弃
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 60秒后重新添加至待请求的队列中
                [self registerItemId:item[kLKLikeManagerItemKeyId]
                                type:item[kLKLikeManagerItemKeyType]
                            isCancel:[item[kLKLikeManagerItemKeyIsCancel] boolValue]];
            });
        });
    }
    [self handleAPIManger:apiManager];
}

- (void)handleAPIManger:(LikeAPIManager *)apiManager {
    OSSpinLockLock(&lk_like_manager_lock);
    if (self.toLikeItems.count != 0) {
        // 如果toLikeItems里还有东西，则继续请求
        [apiManager loadData];
    } else {
        // 否则扔进likeManagers
        [self.loadingLikeManagers removeObject:apiManager];
        [self.likeManagers addObject:apiManager];
    }
    OSSpinLockUnlock(&lk_like_manager_lock);
}

#pragma mark - Private API
- (void)registerItemId:(NSString *)itemId type:(NSString *)type isCancel:(BOOL)isCancel {
    if ([NSString isBlank:type]
        || [NSString isBlank:itemId]) {
        return;
    }
    OSSpinLockLock(&lk_like_manager_lock);

    NSString *key = [NSString stringWithFormat:@"%@_%@",type, itemId];
    self.toLikeItems[key] =
    @{
      kLKLikeManagerItemKeyId : itemId,
      kLKLikeManagerItemKeyType : type,
      kLKLikeManagerItemKeyIsCancel : @(isCancel)
      };
    
    if (self.likeManagers.count > 0) {
        LikeAPIManager *apiManager = [self.likeManagers anyObject];
        [self.likeManagers removeObject:apiManager];
        [self.loadingLikeManagers addObject:apiManager];
        [apiManager loadData];
    } else if (self.loadingLikeManagers.count < maxLikeManagerCount) {
        LikeAPIManager *apiManager = [[LikeAPIManager alloc] init];
        apiManager.delegate = self;
        apiManager.dataSource = self;
        [self.loadingLikeManagers addObject:apiManager];
        [apiManager loadData];
    }
    
    OSSpinLockUnlock(&lk_like_manager_lock);
}

- (NSDictionary *)fetchAnyItem {
    OSSpinLockLock(&lk_like_manager_lock);
    __block NSString *resultKey = nil;
    __block NSDictionary *result = nil;
    [self.toLikeItems enumerateKeysAndObjectsUsingBlock:^(NSString  *key, NSDictionary *item, BOOL * _Nonnull stop) {
        resultKey = key;
        result = item;
        *stop = YES;
    }];
    
    NSString *key = [NSString stringWithFormat:@"%@_%@",result[kLKLikeManagerItemKeyType], result[kLKLikeManagerItemKeyId]];
    self.toLikeItems[key] = nil;
    OSSpinLockUnlock(&lk_like_manager_lock);
    return result;
}

#pragma mark - getter

- (NSMutableSet<LikeAPIManager *> *)likeManagers {
    if (_likeManagers == nil) {
        _likeManagers = [[NSMutableSet alloc] init];
    }
    return _likeManagers;
}

- (NSMutableSet<LikeAPIManager *> *)loadingLikeManagers {
    if (_loadingLikeManagers == nil) {
        _loadingLikeManagers = [[NSMutableSet alloc] init];
    }
    return _loadingLikeManagers;
}

- (NSMutableDictionary *)toLikeItems {
    if (_toLikeItems == nil) {
        _toLikeItems = [[NSMutableDictionary alloc] init];
    }
    return _toLikeItems;
}
@end
