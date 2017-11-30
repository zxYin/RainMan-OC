//
//  CourseManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseManager.h"
#import "Macros.h"
#import "User+Auth.h"
#import "Foundation+LKTools.h"
#import "Foundation+LKCourse.h"
#import "CourseTableAPIManager.h"

@interface CourseManager()
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
@property (nonatomic, strong) CourseTableAPIManager *courseTableAPIManager;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<CourseModel *> *> *mutableCourseTable;
@property (nonatomic, copy) NSArray<CourseModel *> *courseList;
@end

@implementation CourseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}


- (void)setupRAC {
    @weakify(self);

    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSArray<NSArray <CourseModel *> *> *newCourseTable = [self.courseTableAPIManager fetchDataFromModel:[CourseModel class]];
        NSMutableArray *mutableCourseTable = [[NSMutableArray alloc] initWithCapacity:7];
        [newCourseTable enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableCourseTable addObject:
             [[obj sortedArrayUsingSelector:@selector(compare:)] mutableCopy]];
        }];
        
        for (NSInteger i=mutableCourseTable.count; i<7; i++) {
            [mutableCourseTable addObject:[[NSMutableArray alloc] init]];
        }
        
        self.mutableCourseTable = mutableCourseTable;
        [self printCourseTable];
        self.courseTable = [self.mutableCourseTable copy];
        self.loaded = YES;
    }];
    
    [RACObserve(self, courseTable) subscribeNext:^(id x) {
        @strongify(self);
        async_execute(^{
            @try {
                BOOL result = [NSKeyedArchiver archiveRootObject:[CourseManager sharedInstance].courseTable
                                                          toFile:[CourseManager cachePath]];
                NSLog(@"课表Path:%@",[CourseManager cachePath]);
                NSLog(@"[持久化课表]%@",result?@"success":@"fail");
            } @catch (NSException *exception) {
                NSLog(@"持久化课表异常:%@",exception);
            } @finally {
                
            }
            
            [self updateWidgetCourseTable];
            self.courseList = [self.courseList copy];
        });
    }];
}

- (void)updateWidgetCourseTable {
    
    NSMutableArray *widgetCourseTable = [[NSMutableArray alloc] initWithCapacity:7];
    for (NSMutableArray *list in self.courseTable) {
        NSMutableArray *wCourseList = [[NSMutableArray alloc] initWithCapacity:list.count];
        for(CourseModel *courseModel in list) {
            NSMutableDictionary *courseDict = [NSMutableDictionary dictionary];
            courseDict[@"name"] = courseModel.name;
            courseDict[@"time"] = LKTimeFromRange(courseModel.timeRange);
            courseDict[@"locale"] = courseModel.locale;
            courseDict[@"week_set"] = [courseModel.weekFormatter.indexSet lk_allIndexes];
            [wCourseList addObject:[courseDict copy]];
        }
        [widgetCourseTable addObject:[wCourseList copy]];
    }
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:XJTULinkSharedDefaults];
    [shared setObject:[widgetCourseTable copy] forKey:@"course_table"];
    if([shared synchronize]) {
        NSLog(@"更新通知栏课表成功");
    } else {
        NSLog(@"更新通知栏课表失败");
    }
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.courseTableAPIManager;
}

#pragma mark - Helper
- (void)printCourseTable {
    NSInteger i = 0;
    for (NSArray *dayCourses in self.mutableCourseTable) {
        NSLog(@"---------- %td ------------",i++);
        for (CourseModel *course in dayCourses) {
            NSLog(@"%@",course);
        }
    }
}

#pragma mark - getter

- (NSArray<NSArray<CourseModel *> *> *)courseTable {
    if (_courseTable == nil) {
        _courseTable = [self.mutableCourseTable copy];
    }
    return _courseTable;
}

- (NSArray<CourseModel *> *)courseList {
    NSMutableSet *nameSet = [NSMutableSet set];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSMutableArray *list in self.courseTable) {
        for(CourseModel *courseModel in list) {
            if (![nameSet containsObject:courseModel.name]) {
                [resultArray addObject:courseModel];
                [nameSet addObject:courseModel.name];
            }
        }
    }
    return [resultArray count]>0? [resultArray copy]: nil;
}

- (NSMutableArray<NSMutableArray<CourseModel *> *> *)mutableCourseTable {
    if (_mutableCourseTable == nil) {
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:7];
        @try {
            NSArray *courseTable =
            [NSKeyedUnarchiver unarchiveObjectWithFile:[CourseManager cachePath]];
            [courseTable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                
                [result addObject:[NSMutableArray arrayWithArray:[obj sortedArrayUsingSelector:@selector(compare:)]]];
            }];
            
        } @catch (NSException *exception) {
            NSLog(@"读取课表异常:%@",exception);
        } @finally {
            if (result.count != 7) {
                [result removeAllObjects];
                for (NSInteger i=0; i<7; i++) {
                    [result addObject:[NSMutableArray new]];
                }
            } else {
                self.loaded = YES;
            }
            _mutableCourseTable = [result mutableCopy];
        }
    }
    return _mutableCourseTable;
}

- (CourseTableAPIManager *)courseTableAPIManager {
    if (_courseTableAPIManager == nil) {
        _courseTableAPIManager = [[CourseTableAPIManager alloc] init];
    }
    return _courseTableAPIManager;
}

#pragma mark - Public API
- (BOOL)isConflict:(CourseModel *)courseModel {
    if (courseModel == nil) {
        return NO;
    }
    __block BOOL result = NO;
    [self.courseTable[courseModel.weekday] enumerateObjectsUsingBlock:^(CourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isConflictWith:courseModel]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (BOOL)addCourseModel:(CourseModel *)courseModel {
    if (courseModel == nil) {
        return NO;
    }
    
    [self removeCourseWithUUID:courseModel.uuid];
    // 保证不会重复添加
    
    NSMutableArray *dayCourses = self.mutableCourseTable[courseModel.weekday];
    [dayCourses addObject:courseModel];
    [dayCourses sortUsingSelector:@selector(compare:)];
    // 保证按顺序
    
    self.courseTable = [self.mutableCourseTable copy];
    
    return YES;
}

- (void)removeCourseWithUUID:(NSString *)uuid {
    if ([NSString isBlank:uuid]) {
        return;
    }
    
    [self.mutableCourseTable enumerateObjectsUsingBlock:^(NSMutableArray<CourseModel *> * _Nonnull courseModels, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSUInteger removeIndex = -1;
        [courseModels enumerateObjectsUsingBlock:^(CourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uuid isEqualToString:uuid]) {
                removeIndex = idx;
                *stop = YES;
            }
        }];
        if (removeIndex != -1) {
            [courseModels removeObjectAtIndex:removeIndex];
            self.courseTable = [self.mutableCourseTable copy];
        }
    }];
    
}


#pragma mark - Class Method

+ (CourseManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static CourseManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [CourseManager new];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            instance = [CourseManager new];
        }];
    });
    return instance;
}

+ (NSString *)cachePath {
    return [[User sharedInstance].cachePath stringByAppendingPathComponent:kCourseCacheFileName];
}
@end
