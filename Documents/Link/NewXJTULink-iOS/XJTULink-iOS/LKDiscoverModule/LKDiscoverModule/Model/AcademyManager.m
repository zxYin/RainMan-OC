//
//  AcademyManager.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "AcademyManager.h"
#import "AcademyAPIManager.h"
NSString * const kAcademyNotSet = @"学院（未设置）";
@interface AcademyManager()<YLAPIManagerDelegate>
@property (nonatomic, strong) AcademyAPIManager *academyAPIManager;
@end
@implementation AcademyManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AcademyManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [AcademyManager new];
    });
    return instance;
}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    [self setAcademyList:[@[kAcademyNotSet] arrayByAddingObjectsFromArray:[apiManager fetchData]]];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    
}

- (void)setNeedsUpdate {
    [self.academyAPIManager loadData];
}


- (AcademyAPIManager *)academyAPIManager {
    if (_academyAPIManager == nil) {
        _academyAPIManager = [[AcademyAPIManager alloc] init];
        _academyAPIManager.delegate = self;
    }
    return _academyAPIManager;
}

- (NSArray<NSString *> *)academyList {
    NSArray *academyList = [[NSUserDefaults standardUserDefaults] stringArrayForKey:kUserDefaultsAcademyList];
    if (academyList.count == 0) {
        academyList = @[
                        kAcademyNotSet,
                        @"材料学院",
                        @"电信学院",
                        @"电气学院",
                        @"法学院",
                        @"管理学院",
                        @"公管学院",
                        @"航天学院",
                        @"化工学院",
                        @"机械学院",
                        @"经金学院",
                        @"金禾经济中心",
                        @"马克思主义学院",
                        @"能动学院",
                        @"前沿院",
                        @"软件学院",
                        @"人居学院",
                        @"人文学院",
                        @"食品装备学院",
                        @"生命学院",
                        @"数学学院",
                        @"外国语学院",
                        @"医学院"
                        ];
        [self setAcademyList:academyList];
    }
    return academyList;
}

- (void)setAcademyList:(NSArray<NSString *> *)academyList {
    [[NSUserDefaults standardUserDefaults] setObject:academyList forKey:kUserDefaultsAcademyList];
}


@end
