//
//  User.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "User.h"
#import "User+Persistence.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "UserAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
@interface User()<YLAPIManagerDelegate> {
    UserAPIManager *_userAPIManager;
}
@property (nonatomic, strong, readonly) UserAPIManager *userAPIManager;
@end
@implementation User

+ (void)load {
    [User userAutoSave];
}

+ (User *)sharedInstance {
    static dispatch_once_t onceToken;
    static User *instance;
    dispatch_once(&onceToken, ^{
        instance = [User userFromFile]?:[[User alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:LKNotificationUserDidLogout object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [User clearKeychain];
            
            instance = [[User alloc] init];
        }];
        
        NSLog(@"Load User:%@",instance);
    });
    return instance;
}

- (NSString *)netId {
    if (_netId == nil) {
        _netId = [User passwordFromKeyChain:self.userId];
    }
    return _netId;
}


- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"未找到key:%@",key);
    return nil;
}

+ (void)RESET {
    User *user = [User sharedInstance];
    user.userId = nil;
    user.nickname = nil;
    user.name = nil;
    user.number = nil;
    user.netId = nil;
    user.major = nil;
    user.avatarURL = nil;
    user.type = 0;
    
    [User removeUserFile];
}

+ (BOOL)isLogined {
    return [NSString notBlank:LKUserInstance.userId];
}


- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.userAPIManager;
}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    NSDictionary *userInfo = [apiManager fetchData];
    self.nickname = [userInfo stringForKey:@"nickname"];
    self.academy = [userInfo stringForKey:@"academy"];
    self.college = [userInfo stringForKey:@"college"];
    self.major = [userInfo stringForKey:@"major"];
    self.number = [userInfo stringForKey:@"num"];
    self.avatarURL = [userInfo stringForKey:@"portrait"];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    
}

#pragma mark - Getter & Setter

- (NSString *)description {
    return [NSString stringWithFormat:@"userId:%@,nickname:%@,name:%@,number:%@,netId:%@,major:%@,avatarURL:%@",
                                    self.userId,self.nickname,self.name,self.number,self.netId,self.major,self.avatarURL];
}

- (UserAPIManager *)userAPIManager {
    if (_userAPIManager == nil) {
        _userAPIManager = [[UserAPIManager alloc] init];
        _userAPIManager.delegate = self;
    }
    return _userAPIManager;
}

@end



