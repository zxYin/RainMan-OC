//
//  LKMessageManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageManager.h"
#import "Foundation+LKTools.h"
#import "LKMessageCountAPIManager.h"
#import "Macros.h"
#import "NSDictionary+LKValueGetter.h"

NSString * const LKMessageCountKeyTotal = @"LKMessageCountKeyTotal";

static NSString * const LKMessageTypeKeyMessageClass;

@interface LKMessageManager()<YLAPIManagerDelegate>
@property (nonatomic, strong) LKMessageCountAPIManager *countAPIManager;
@property (nonatomic, strong) NSMutableDictionary *messageDict;
@end

@implementation LKMessageManager

+ (void)load {
    async_execute_after_launching(^{
        [[LKMessageManager sharedInstance].countAPIManager loadData];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKMessageManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKMessageManager alloc] init];
    });
    return instance;
}

- (void)registerMessageClass:(Class<LKMessage>)messageClass {
    if (messageClass == nil) {
        return;
    }
    NSString *key = [messageClass type];
#ifdef DEBUG
    if (self.messageDict[key]) {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"[%@] regiter <%@> ERROR",[self class],key]
                                       reason:@"Multiple Registers"
                                     userInfo:nil];
    }
#endif
    self.messageDict[key] = messageClass;
}

- (void)configTableViewRegisters:(UITableView *)tableView {
    if (![tableView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    [self.messageDict enumerateKeysAndObjectsUsingBlock:^(NSString *type, Class<LKMessage> messageClass, BOOL * _Nonnull stop) {
        NSString *cellName = [messageClass cellName];
        NSString *path = [[NSBundle mainBundle] pathForResource:cellName ofType:@"nib"];
        if (path != nil) {
            UINib *nib = [UINib nibWithNibName:cellName  bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellName];
        } else {
            [tableView registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellName];
        }
    }];
}

- (Class)classForType:(NSString *)type {
    if ([NSString isBlank:type]) {
        return nil;
    }
    
    return self.messageDict[type];
}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    NSInteger totalCount = [[[apiManager fetchData] dictionaryForKey:@"data"] integerForKey:@"total_count"];
    self.unreadMessageCount = totalCount;
    
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    
}


#pragma mark - Getter
- (NSMutableDictionary *)messageDict {
    if (_messageDict == nil) {
        _messageDict = [[NSMutableDictionary alloc] init];
    }
    return _messageDict;
}

- (NSArray<Class> *)allMessageTypes {
    return [self.messageDict allKeys];
}

- (LKMessageCountAPIManager *)countAPIManager {
    if (_countAPIManager == nil) {
        _countAPIManager = [[LKMessageCountAPIManager alloc] init];
        _countAPIManager.delegate = self;
    }
    return _countAPIManager;
}
@end
