//
//  User+Persistence.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "User.h"
@interface User (Persistence)
+ (void)saveToFile;
+ (void)userAutoSave;
+ (void)removeUserFile;
+ (User *)userFromFile;

+ (void)saveToken:(NSString *)token forUserId:(NSString *)userId;

+ (void)saveNetId:(NSString *)netId
         password:(NSString *)password
            token:(NSString *)token
          forUser:(NSString *)userId;

+ (NSString *)passwordFromKeyChain:(NSString *)netId;
+ (NSString *)userTokenFromKeyChain:(NSString *)userId;
+ (NSString *)netIdFromKeyChain:(NSString *)userId;

+ (NSString *)libraryUsernameFromKeyChain:(NSString *)userId;
+ (NSString *)libraryPasswordFromKeyChain:(NSString *)userId;


+ (void)saveLibUsername:(NSString *)username
            libPassword:(NSString *)password
                forUser:(NSString *)userId;

+ (void)clearKeychain;


+ (NSString *)savePassword:(NSString *)password forService:(NSString *)service account:(NSString *)account;
@end
