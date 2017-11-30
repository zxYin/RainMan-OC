//
//  LKVersionManager.m
//  LKStartupModule
//
//  Created by Yunpeng on 2016/12/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKVersionManager.h"
#import "LKVersionAPIManager.h"
#import "AppContext.h"
#import "Macros.h"
#import "TBActionSheet.h"
#import "LKUpdateAlertView.h"
#import "LKNoticeAlert.h"
#import "Foundation+LKTools.h"
#import "NSDictionary+LKValueGetter.h"
#import "LKUpdateViewController.h"
@interface NSString (VersionManager)

@end
@implementation NSString (VersionManager)
- (BOOL)isEarlierThanVersion:(NSString *)version {
    __block BOOL result = NO;
    NSArray *components = [self componentsSeparatedByString:@"."];
    NSArray *targetComponents = [version componentsSeparatedByString:@"."];
    [components enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < targetComponents.count) {
            NSComparisonResult c = [obj compare:targetComponents[idx]];
            switch (c) {
                case NSOrderedAscending:
                    result = YES;
                    break;
                case NSOrderedDescending:
                    *stop = YES;
                    break;
                default:
                    break;
            }
        } else {
            *stop = YES;
        }
    }];
    return result;
}
@end



@interface LKVersionManager()<YLAPIManagerDelegate>
@property (nonatomic, strong) LKVersionAPIManager *versionAPIManager;
@end

@implementation LKVersionManager
+ (void)load {
    async_execute_after_launching(^{
        [[LKVersionManager sharedInstance].versionAPIManager loadData];
    });
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKVersionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKVersionManager alloc] init];
    });
    return instance;
}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    
    NSDictionary *info = [apiManager fetchData];

    NSString *version = [info stringForKey:@"version"];
    BOOL isForced = [info boolForKey:@"is_forced"];
    NSString *message = [info stringForKey:@"message"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (![currentVersion isEarlierThanVersion:version]) {
        return;
    }
    
    if (isForced) {
        UIViewController *currentVC = [[AppContext sharedInstance] currentViewController];
        UIViewController *vc = [[LKUpdateViewController alloc] init];
        [currentVC presentViewController:vc animated:YES completion:nil];
    }
    
    
    NSInteger lastAlertTime =  [LKUserDefaults integerForKey:LKUserDefaultsNewVersionLastAlert];
    // 24小时以内不重复弹窗
    if ([[NSDate date] timeIntervalSince1970] - lastAlertTime < 60 * 60 * 24) {
        return;
    }
    
    NSData *skipVersionsData = [LKUserDefaults objectForKey:LKUserDefaultsSkipVersions];
    __block NSSet *skipVersions = [NSKeyedUnarchiver unarchiveObjectWithData:skipVersionsData];
    NSLog(@"skipVersions:%@",skipVersions);
    if ([NSString isBlank:version]
        ||[skipVersions containsObject:version]) {
        return;
    }
    
    LKUpdateAlertView *contentView =
    [LKUpdateAlertView viewWithUpdateBlock:^{
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStorePath]];
    } skipBlock:^{
        if (skipVersions == nil) {
            skipVersions = [NSSet setWithObject:version];
        } else {
            skipVersions = [skipVersions setByAddingObject:version];
        }
        [LKUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:skipVersions]
                           forKey:LKUserDefaultsSkipVersions];
    }];
    
    contentView.contentLabel.text = message;
    
    LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
    [alert show];
    
    NSInteger alertTime = [[NSDate date] timeIntervalSince1970];
    [LKUserDefaults setInteger:alertTime forKey:LKUserDefaultsNewVersionLastAlert];
    
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    NSLog(@"检测新版本失败");
}

#pragma mark - getter
- (LKVersionAPIManager *)versionAPIManager {
    if (_versionAPIManager == nil) {
        _versionAPIManager = [[LKVersionAPIManager alloc] init];
        _versionAPIManager.delegate = self;
    }
    return _versionAPIManager;
}

@end
