//
//  ScheduleManager.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/12.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleManager.h"
#import "Macros.h"
#import "User+Auth.h"
#import "ScheduleAPIManager.h"
#import "NSDate+DateTools.h"
#import "LocalNotificationManager.h"

#define kScheduleLocalNotificationKey @"schedule_%td_%td"
@interface ScheduleManager()
@property (nonatomic, strong) ScheduleAPIManager *scheduleAPIManager;
@property (nonatomic, copy) NSArray<ScheduleModel *> *scheduleModels;
@end

@implementation ScheduleManager
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)addScheduleModel:(ScheduleModel *)scheduleModel {
    self.scheduleModels = [self.scheduleModels arrayByAddingObject:scheduleModel];
    [self registerLocalNotificationWithScheduleModel:scheduleModel];
    [self sort];
    [self asyncArchive];
}

- (void)deleteScheduleModelWithEventId:(NSInteger)eventId {
    for (ScheduleModel *model in self.scheduleModels) {
        if (model.eventId == eventId) {
            [self cancelLocalNotificationWithScheduleModel:model];
            self.scheduleModels = [self.scheduleModels mtl_arrayByRemovingObject:model];
        }
    }
    [self asyncArchive];
}

- (void)updateScheduleModel:(ScheduleModel *)scheduleModel {
    for (ScheduleModel *model in self.scheduleModels) {
        if (model.eventId == scheduleModel.eventId) {
            model.name = scheduleModel.name;
            model.time = scheduleModel.time;
            model.locale = scheduleModel.locale;
            [self cancelLocalNotificationWithScheduleModel:model];
            [self registerLocalNotificationWithScheduleModel:model];
        }
    }
    [self sort];
    [self asyncArchive];
}

- (ScheduleModel *)fetchScheduleModelForKey:(NSString *)key {
    __block ScheduleModel *model = nil;
    [self.scheduleModels enumerateObjectsUsingBlock:^(ScheduleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:key]) {
            model = obj;
        }
    }];
    return model;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSArray *scheduleModels = [self.scheduleAPIManager fetchDataFromModel:ScheduleModel.class];
        
        self.scheduleModels = scheduleModels;
        [self sort];
        [self asyncArchive];
    }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.scheduleAPIManager;
}

- (void)asyncArchive {
    async_execute(^{
        @try {
            BOOL result = [NSKeyedArchiver archiveRootObject:[ScheduleManager sharedInstance].scheduleModels
                                                      toFile:[ScheduleManager cachePath]];
            NSLog(@"[持久化考试安排]%@",result?@"success":@"fail");
        } @catch (NSException *exception) {
            NSLog(@"持久化考试安排异常:%@",exception);
        } @finally {
            
        }
    });
}

- (void)sort {
    self.scheduleModels = [self.scheduleModels sortedArrayUsingComparator:^NSComparisonResult(ScheduleModel *obj1, ScheduleModel *obj2) {
        NSTimeInterval ts1 = obj1.timestamp;
        NSTimeInterval ts2 = obj2.timestamp;
        if (ts1 < [[NSDate date] timeIntervalSince1970]) {
            ts1 += [[NSDate distantFuture] timeIntervalSince1970];
        }
        if (ts2 < [[NSDate date] timeIntervalSince1970]) {
            ts2 += [[NSDate distantFuture] timeIntervalSince1970];
        }
        if (ts1 < ts2) {
            return NSOrderedAscending;
        } else if (ts1 > ts2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (void)registerLocalNotificationWithScheduleModel:(ScheduleModel *)model {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.timestamp - 60*30];
    if ([[NSDate date] isEarlierThan:date]) {
        NSString *msg = [NSString stringWithFormat:@"你的【%@】考试马上就要开始了，别迟到哦~！", model.name];
        NSString *key = [NSString stringWithFormat:kScheduleLocalNotificationKey, model.eventId, (NSInteger)0];
        [LocalNotificationManager registerLocalNotificationWithMessage:msg
                                                                atDate:date
                                                                   url:@"xjtulink://course/schedule/"
                                                                forKey:key];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:model.timestamp]];
    
    components.hour += 8;
    NSDate *dateToday = [calendar dateFromComponents:components];
    if ([[NSDate date] isEarlierThan:dateToday]) {
        NSString *timeString = [[NSDate dateWithTimeIntervalSince1970:model.timestamp] formattedDateWithFormat:@"HH:mm"];
        NSString *msg = [NSString stringWithFormat:@"你的【%@】考试就在今天【%@】，请准时参加！", model.name, timeString];
        NSString *key = [NSString stringWithFormat:kScheduleLocalNotificationKey, model.eventId, (NSInteger)1];
        [LocalNotificationManager registerLocalNotificationWithMessage:msg
                                                                atDate:dateToday
                                                                   url:@"xjtulink://course/schedule/"
                                                                forKey:key];
    }
    
    components.day -= 3;
    NSDate *dateEarlierThan1Day = [calendar dateFromComponents:components];
    if ([[NSDate date] isEarlierThan:dateEarlierThan1Day]) {
        NSString *msg = [NSString stringWithFormat:@"距离你的【%@】考试还剩三天，复习得如何？", model.name];
        NSString *key = [NSString stringWithFormat:kScheduleLocalNotificationKey, model.eventId, (NSInteger)2];
        [LocalNotificationManager registerLocalNotificationWithMessage:msg
                                                                atDate:dateEarlierThan1Day
                                                                   url:@"xjtulink://course/schedule/"
                                                                forKey:key];
    }
    
    components.day -= 4;
    NSDate *dateEarlierThan7Day = [calendar dateFromComponents:components];
    if ([[NSDate date] isEarlierThan:dateEarlierThan7Day]) {
        NSString *msg = [NSString stringWithFormat:@"你的【%@】考试还剩一周的复习时间哦~", model.name];
        NSString *key = [NSString stringWithFormat:kScheduleLocalNotificationKey, model.eventId, (NSInteger)3];
        [LocalNotificationManager registerLocalNotificationWithMessage:msg
                                                                atDate:dateEarlierThan7Day
                                                                   url:@"xjtulink://course/schedule/"
                                                                forKey:key];
    }
}

- (void)cancelLocalNotificationWithScheduleModel:(ScheduleModel *)model {
    for (NSInteger i=0; i<4; i++) {
        NSString *key = [NSString stringWithFormat:kScheduleLocalNotificationKey, model.eventId, i];
        [LocalNotificationManager cancelLocalNotificationWithKey:key];
    }
}

#pragma mark - getter

- (NSArray<ScheduleModel *> *)scheduleModels {
    if (_scheduleModels == nil) {
        @try {
            _scheduleModels =
            [NSKeyedUnarchiver unarchiveObjectWithFile:
             [ScheduleManager cachePath]];
            NSLog(@"加载考试安排成功");
        } @catch (NSException *exception) {
            NSLog(@"读取考试安排异常:%@",exception);
        } @finally {
            
        }
    }
    return _scheduleModels;
}

- (ScheduleAPIManager *)scheduleAPIManager {
    if (_scheduleAPIManager == nil) {
        _scheduleAPIManager = [ScheduleAPIManager apiManagerByType:ScheduleAPIManagerTypeGet];
    }
    return _scheduleAPIManager;
}

#pragma mark - Class Method
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ScheduleManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ScheduleManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            instance = [[ScheduleManager alloc] init];
        }];
    });
    return instance;
}

+ (NSString *)cachePath {
    return [[User sharedInstance].cachePath stringByAppendingPathComponent:kScheduleCacheFileName];
}
@end
