//
//  User+Auth.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface User (Auth)
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy, readonly) NSString *userToken;
@property (nonatomic, copy, readonly) NSString *newUserToken;
@property (nonatomic, copy, readonly) NSString *userTokenNoTimestamp;

@property (nonatomic, copy, readonly) NSString *libUsername;
@property (nonatomic, copy, readonly) NSString *libPassword;


- (NSString *)unencryptedRequestToken;
- (NSString *)unencryptedNewRequestToken;

- (void)tryUpdateUserToken:(NSString *)userToken;
- (void)newUserTokenDidVerify;

- (NSString *)identifier;
- (NSString *)cachePath;
@end
