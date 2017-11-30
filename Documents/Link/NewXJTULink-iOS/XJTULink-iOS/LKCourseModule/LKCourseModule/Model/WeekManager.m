//
//  WeekManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WeekManager.h"
#import "Macros.h"
#import "WeekAPIManager.h"
#import <UIKit/UIKit.h>

NSString * const LKNotificationWeekDidUpdate = @"LKNotificationWeekDidUpdate";
@interface WeekManager()<YLAPIManagerDelegate>
@property (nonatomic, strong) WeekAPIManager *weekAPIManager;
@end


@implementation WeekManager
@dynamic week;

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    NSInteger newWeek = [[apiManager fetchData] integerValue];
    if (newWeek != self.week) {
        self.week = newWeek;
        [[NSNotificationCenter defaultCenter] postNotificationName:LKNotificationWeekDidUpdate object:@(newWeek)];
    }
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    NSLog(@"更新周失败");
}

+ (void)load {
    async_execute_after_launching(^{
        [[WeekManager sharedInstance].weekAPIManager loadData];
    });
}

+ (WeekManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WeekManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [WeekManager new];
    });
    return instance;
}


- (NSInteger)week {
    NSInteger week = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsCurrentWeek];
    if (week <= 0) {
        week = 1;
        [self setWeek:week];
    }
    return week;
}


- (void)setWeek:(NSInteger)week {
    [[NSUserDefaults standardUserDefaults] setInteger:week forKey:kUserDefaultsCurrentWeek];
}


- (WeekAPIManager *)weekAPIManager {
    if (_weekAPIManager == nil) {
        _weekAPIManager = [[WeekAPIManager alloc] init];
        _weekAPIManager.delegate = self;
    }
    return _weekAPIManager;
}




@end
