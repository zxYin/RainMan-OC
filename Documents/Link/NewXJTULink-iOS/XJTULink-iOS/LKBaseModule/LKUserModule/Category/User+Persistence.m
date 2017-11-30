//
//  User+Persistence.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "User+Persistence.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "SAMKeychain.h"

@implementation User (Persistence)

+ (void)saveToFile {
    async_execute(^{
        if ([NSString notBlank:LKUserInstance.userId]) {
            @try {
                BOOL result = [NSKeyedArchiver archiveRootObject:LKUserInstance toFile:[self filePathOfUser]];
                NSLog(@"[持久化]%@",result?@"success":@"fail");
            } @catch (NSException *exception) {
                NSLog(@"持久化User异常:%@",exception);
            } @finally {
                
            }
        }
    });
}
+ (void)userAutoSave {
    // 确保只被执行一次
    async_execute_before_resign_active(^{
        [self saveToFile];
    });
}

+ (void)saveToken:(NSString *)token forUserId:(NSString *)userId {
    if ([NSString isBlank:userId]
        || [NSString isBlank:token]
        ) return;
    [SAMKeychain setPassword:token forService:KeychainKeyToken account:KeychainKeyAccount(userId)];
}


+ (NSString *)passwordFromKeyChain:(NSString *)netId {
    return  [self fetchPasswordForService:KeychainKeyPassword account:netId];
}

+ (NSString *)userTokenFromKeyChain:(NSString *)userId {
    return [self fetchPasswordForService:KeychainKeyToken account:userId];
}

+ (NSString *)netIdFromKeyChain:(NSString *)userId {
    return [self fetchPasswordForService:KeychainKeyNetId account:userId];
}

+ (NSString *)libraryUsernameFromKeyChain:(NSString *)userId {
    return [self fetchPasswordForService:KeychainKeyLibraryUsername account:userId];
}

+ (NSString *)libraryPasswordFromKeyChain:(NSString *)userId {
    return [self fetchPasswordForService:KeychainKeyLibraryPassword account:userId];
}

+ (void)saveNetId:(NSString *)netId
         password:(NSString *)password
            token:(NSString *)token
          forUser:(NSString *)userId {
    if ([NSString isBlank:userId]) return;
    [self saveToken:token forUserId:userId];
    
    if ([NSString isBlank:netId]
        || [NSString isBlank:password]
        ) return;
    
    [SAMKeychain setPassword:netId forService:KeychainKeyNetId account:KeychainKeyAccount(userId)];
    [SAMKeychain setPassword:password forService:KeychainKeyPassword account:KeychainKeyAccount(netId)];
}

+ (void)saveLibUsername:(NSString *)username
            libPassword:(NSString *)password
                forUser:(NSString *)userId{
     if ([NSString isBlank:userId]
         || [NSString isBlank:username]
         || [NSString isBlank:password]) return;
    
    [SAMKeychain setPassword:username forService:KeychainKeyLibraryUsername account:KeychainKeyAccount(userId)];
    [SAMKeychain setPassword:password forService:KeychainKeyLibraryPassword account:KeychainKeyAccount(userId)];
}

+ (void)clearKeychain {
    for(NSDictionary *accountInfo in [SAMKeychain allAccounts]) {
        NSString *account = accountInfo[kSAMKeychainAccountKey];
        [SAMKeychain deletePasswordForService:KeychainKeyLibraryUsername account:account];
        [SAMKeychain deletePasswordForService:KeychainKeyLibraryPassword account:account];
        [SAMKeychain deletePasswordForService:KeychainKeyNetId account:account];
        [SAMKeychain deletePasswordForService:KeychainKeyToken account:account];
        [SAMKeychain deletePasswordForService:KeychainKeyPassword account:account];
    }
}

+ (void)removeUserFile {
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathOfUser] error:NULL];
}

+ (User *)userFromFile {
    id user;
    @try {
        user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathOfUser]];
    } @catch (NSException *exception) {
        NSLog(@"读取User异常:%@",exception);
    } @finally {
        if ([user isKindOfClass:User.class] && [NSString notBlank:[user userId]]) {
            NSLog(@"读取user:%@",((User *)user).userId);
            return user;
        } else {
            NSLog(@"未找到用户文件");
            return nil;
        }
    }
}


+ (NSString *)filePathOfUser {
    return [AppDocumentPath stringByAppendingPathComponent:kUserCacheFileName];
}


#pragma mark - Private API

+ (NSString *)fetchPasswordForService:(NSString *)service account:(NSString *)account {
    NSString *result = [SAMKeychain passwordForService:service account:KeychainKeyAccount(account)];
    if ([NSString isBlank:result]) {
        // 兼容老版本
        result = [SAMKeychain passwordForService:service account:account];
        
        if ([NSString notBlank:result]) {
            // 如果出现老版本的情况，则将其更新为新的存储方式
            [SAMKeychain deletePasswordForService:service account:account];
            [SAMKeychain setPassword:result forService:service account:KeychainKeyAccount(account)];
        }
    }
    return result;
}

@end
