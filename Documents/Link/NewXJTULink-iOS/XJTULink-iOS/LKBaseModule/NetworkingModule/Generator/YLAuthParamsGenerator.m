//
//  YLAuthParamsGenerator.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAuthParamsGenerator.h"
//#import "OUser.h"
#import "Constants.h"
#import "Foundation+LKTools.h"
#import "User+Auth.h"
NSString * const kYLAuthParamsKeyUserId = @"user_id"; //在此修改为userId对应的key
NSString * const kYLAuthParamsKeyUserToken = @"user_token";
NSString * const kYLAuthParamsKeyNewUserToken = @"new_user_token";
@implementation YLAuthParamsGenerator
+ (NSDictionary *)authParams {
    User *user = [User sharedInstance];
    if ([NSString isBlank:user.userId]
        || [NSString isBlank:user.userToken]) {
        return nil;
    }
    
    NSMutableDictionary *authParams = [[NSMutableDictionary alloc] init];
    authParams[kYLAuthParamsKeyUserId] = user.userId;
    authParams[kYLAuthParamsKeyUserToken] = user.userToken;
    
    // new_user_token有可能为空，但是不影响
    authParams[kYLAuthParamsKeyNewUserToken] = user.newUserToken;
    
    NSLog(@"user_id:%@, userToken:%@ rawToken:%@ newUserToken:%@", authParams[@"user_id"], authParams[@"user_token"], [user unencryptedRequestToken],authParams[@"new_user_token"]);
    return [authParams copy];
}
@end



@implementation NSDictionary (YLAuthParams)

- (NSDictionary *)dictionaryExceptToken {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
//    NSArray<NSString *> *keys = [YLAuthParamsGenerator authParams].allKeys;
    // 这里保留UserId以防止不同用户的脏数据
//    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (![obj isEqualToString:kYLAuthParamsKeyUserId]) {
//            [dict removeObjectForKey:obj];
//        }
//    }];
//
    [dict removeObjectsForKeys:@[kYLAuthParamsKeyUserToken,
                                 kYLAuthParamsKeyNewUserToken,
                                 @"lib_password"]];
    return [dict copy];
}
@end
