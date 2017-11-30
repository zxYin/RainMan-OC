//
//  User+Auth.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "User+Auth.h"
#import "LKSecurity.h"
#import "Constants.h"
#import "Foundation+LKTools.h"
#import "User+Persistence.h"
#import <objc/runtime.h>
#import "LKTranscoder.h"
#import "Macros.h"
#import "AppContext.h"

NSString *encryptToken(NSString *rawToken) {
    if ([NSString isBlank:rawToken]) {
        return nil;
    }
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString *unencryptedRequestToken = [rawToken stringByAppendingFormat:@"::%td",time];
    return [[LKSecurity sharedInstance] rsaEncryptString:unencryptedRequestToken];

}

@implementation User (Auth)

- (NSString *)unencryptedRequestToken {
    return [User userTokenFromKeyChain:self.userId];
}

- (NSString *)unencryptedNewRequestToken {
    return objc_getAssociatedObject(self, @selector(newUserToken));
}

- (NSString *)userTokenNoTimestamp {
    NSString *encryptedAccessToken = [User userTokenFromKeyChain:self.userId];
    return [[LKSecurity sharedInstance] rsaEncryptString:encryptedAccessToken];
}

- (NSString *)userToken {
    return encryptToken([User userTokenFromKeyChain:self.userId]);
}

- (NSString *)newUserToken {
//    return @"test";
    return encryptToken(objc_getAssociatedObject(self, @selector(newUserToken)));
}

- (void)tryUpdateUserToken:(NSString *)userToken {
    NSLog(@"尝试更新Token: %@",userToken);
    objc_setAssociatedObject(self, @selector(newUserToken), userToken, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)newUserTokenDidVerify {
    NSString *newUserToken = objc_getAssociatedObject(self, @selector(newUserToken));
    if (newUserToken != nil) {
        
#ifdef DEBUG
        [AppContext showProgressHUDWithMessage:@"Token验证成功" image:[UIImage imageNamed:@"hud_icon_checkmark"]];
#endif
        [User saveToken:newUserToken forUserId:self.userId];
        objc_setAssociatedObject(self, @selector(newUserToken), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 持久化
        [User saveToFile];
    }
}

- (NSString *)password {
    return [User passwordFromKeyChain:self.netId];
}

- (NSString *)libUsername {
    return [User libraryUsernameFromKeyChain:self.userId];
}

- (NSString *)libPassword {
    return [[LKSecurity sharedInstance] rsaEncryptString:[User libraryPasswordFromKeyChain:self.userId]];
}

- (NSString *)identifier {
    return [[NSString stringWithFormat:@"%@:%@",self.netId,self.userId] md5String];
}

- (NSString *)cachePath {
    // 由于这是User必须的文件，所以此处使用的是AppDocumentPath而不是AppCachePath
    NSString *cachePath = [AppDocumentPath stringByAppendingPathComponent:self.identifier];
    
    // 保证目录存在
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return cachePath;
}
@end
