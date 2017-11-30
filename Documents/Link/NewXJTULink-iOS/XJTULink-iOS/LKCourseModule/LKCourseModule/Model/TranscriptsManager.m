//
//  TranscriptsManager.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsManager.h"
#import "Macros.h"
#import "User+Auth.h"
#import "TranscriptsAPIManager.h"
@interface TranscriptsManager()
@property (nonatomic, strong) TranscriptsAPIManager *transcriptsAPIManager;

@property (nonatomic, copy) NSDictionary<NSString *, NSArray<TranscriptsItemModel *> *> *transcripts;
@end

@implementation TranscriptsManager

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
        NSArray *scoreList = [self.transcriptsAPIManager fetchData];
        NSMutableDictionary *transcripts = [[NSMutableDictionary alloc]initWithCapacity:scoreList.count];
        for (NSArray *scores in scoreList) {
            NSArray *scoreModels = [MTLJSONAdapter modelsOfClass:TranscriptsItemModel.class
                                                   fromJSONArray:scores error:NULL];
            
            TranscriptsItemModel *model = scoreModels.firstObject;
            if (model != nil) {
                NSString *key = [NSString stringWithFormat:@"%@ %@",model.schoolYear, model.semester];
                [transcripts setValue:scoreModels forKey:key];
            }
        }
        self.transcripts = [transcripts copy];
        
        async_execute(^{
            @try {
                BOOL result = [NSKeyedArchiver archiveRootObject:[TranscriptsManager sharedInstance].transcripts
                                                          toFile:[TranscriptsManager cachePath]];
                NSLog(@"[持久化成绩]%@",result?@"success":@"fail");
            } @catch (NSException *exception) {
                NSLog(@"持久化成绩异常:%@",exception);
            } @finally {
                
            }
        });
        
    }];
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.transcriptsAPIManager;
}

#pragma mark - getter

- (NSDictionary<NSString *,NSArray<TranscriptsItemModel *> *> *)transcripts {
    if (_transcripts == nil) {
        @try {
            _transcripts =
            [NSKeyedUnarchiver unarchiveObjectWithFile:
             [TranscriptsManager cachePath]];
            NSLog(@"加载成绩成功");
        } @catch (NSException *exception) {
            NSLog(@"读取成绩异常:%@",exception);
        } @finally {
            
        }
    }
    return _transcripts;
}

- (TranscriptsAPIManager *)transcriptsAPIManager {
    if (_transcriptsAPIManager == nil) {
        _transcriptsAPIManager = [[TranscriptsAPIManager alloc] init];
    }
    return _transcriptsAPIManager;
}


#pragma mark - Class Method
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TranscriptsManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TranscriptsManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            instance = [[TranscriptsManager alloc] init];
        }];
    });
    return instance;
    
}

+ (NSString *)cachePath {
    return [[User sharedInstance].cachePath stringByAppendingPathComponent:kTranscriptsCacheFileName];
}

@end
