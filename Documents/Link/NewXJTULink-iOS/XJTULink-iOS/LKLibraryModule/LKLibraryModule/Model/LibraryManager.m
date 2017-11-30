//
//  LibraryManager.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryManager.h"
#import "Macros.h"
#import "LibraryAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
#import "User+Auth.h"
#import "AppContext.h"
#import "LocalNotificationManager.h"
#import "NSDate+LKTools.h"

@interface LibraryManager()<YLAPIManagerDataSource> {
    // 这种写法避免Mantle持久化_libraryAPIManager
    LibraryAPIManager *_libraryAPIManager;
}
@property (nonatomic, strong, readonly) LibraryAPIManager *libraryAPIManager;
@end

@implementation LibraryManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *libInfo = [self.libraryAPIManager fetchData];
        self.fine = [libInfo stringForKey:@"fine" defaultValue:@"0.00"];
        
        
        // 取消注册之前的借阅通知
        [self.libBookModels enumerateObjectsUsingBlock:^(LibBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [LocalNotificationManager cancelLocalNotificationWithKey:obj.uuid];
        }];
        
        self.libBookModels = [MTLJSONAdapter modelsOfClass:[LibBookModel class]
                                             fromJSONArray:libInfo[@"book_list"]
                                                     error:nil];
        
        [self.libBookModels enumerateObjectsUsingBlock:^(LibBookModel * book, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *msg = [NSString stringWithFormat:@"你借阅的《%@》要到期了！快去看看。",book.name];
            NSDate *date = [[NSDate dateWithString:[NSString stringWithFormat:@"%@ 09:30:00",book.date]
                                      formatString:@"yyyy-MM-dd HH:mm:ss"]
                            dateBySubtractingDays:3];
            if ([[NSDate date] isEarlierThan:date]) {
                [LocalNotificationManager registerLocalNotificationWithMessage:msg
                                                                        atDate:date
                                                                           url:@"xjtulink://library/"
                                                                        forKey:book.uuid];
            }
        }];
        
        async_execute(^{
            NSLog(@"持久化借阅信息开始...");
            @try {
                BOOL result = [NSKeyedArchiver archiveRootObject:[LibraryManager sharedInstance]
                                                          toFile:[LibraryManager cachePath]];
                NSLog(@"[持久化借阅信息]%@",result?@"success":@"fail");
            } @catch (NSException *exception) {
                NSLog(@"持久化借阅信息异常:%@",exception);
            } @finally {
                
            }
        });
        
    }];
}


- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.libraryAPIManager == manager) {
        User *user = [User sharedInstance];
        params[kLibraryAPIManagerParamsKeyLibUsername] = user.libUsername;
        params[kLibraryAPIManagerParamsKeyLibPassword] = user.libPassword;
    }
    return [params copy];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LibraryManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [self managerFromFile]?:
        [[LibraryManager alloc] init];
        [instance setupRAC];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            // 取消注册的借阅通知
            [instance.libBookModels enumerateObjectsUsingBlock:^(LibBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [LocalNotificationManager cancelLocalNotificationWithKey:obj.uuid];
            }];
            
            instance = [[LibraryManager alloc] init];
            [instance setupRAC];
        }];
    });
    return instance;
}




#pragma mark - Persistence
+ (LibraryManager *)managerFromFile {
    LibraryManager *manager;
    @try {
        manager = [NSKeyedUnarchiver unarchiveObjectWithFile:[LibraryManager cachePath]];
    } @catch (NSException *exception) {
        NSLog(@"读取LibraryManager异常:%@",exception);
    } @finally {
        if ([manager isKindOfClass:LibraryManager.class]) {
            NSLog(@"读取LibraryManager");
            return manager;
        } else {
            NSLog(@"未找到LibraryManager文件");
            return nil;
        }
    }
}

+ (NSString *)cachePath {
    return [[User sharedInstance].cachePath stringByAppendingPathComponent:kLibraryCacheFileName];
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.libraryAPIManager;
}

#pragma mark - Getter
- (LibraryAPIManager *)libraryAPIManager {
    if (_libraryAPIManager == nil) {
        _libraryAPIManager = [LibraryAPIManager new];
        _libraryAPIManager.dataSource = self;
    }
    return _libraryAPIManager;
}

@end
