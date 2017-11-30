//
//  User.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "LKNetworking.h"
#define LKUserInstance [User sharedInstance]
/// 用户类型
typedef NS_ENUM(NSInteger, UserType) {
    UserTypeStudent = 1,
    UserTypeTeacher = 2,
};

@interface User : MTLModel<MTLJSONSerializing, YLNetworkingRACProtocol>

/// User ID
@property (nonatomic, copy) NSString *userId;

/// 昵称
@property (nonatomic, copy) NSString *nickname;

/// 真实姓名
@property (nonatomic, copy) NSString *name;

/// 学号
@property (nonatomic, copy) NSString *number;

/// Net ID
@property (nonatomic, copy) NSString *netId;

/// 专业
@property (nonatomic, copy) NSString *major;

/// 书院
@property (nonatomic, copy) NSString *academy;

/// 学院
@property (nonatomic, copy) NSString *college;

/// 类型
@property (nonatomic, assign) UserType type;

@property (nonatomic, copy) NSString *avatarURL;


+ (instancetype)sharedInstance;
+ (void)RESET;
+ (BOOL)isLogined;
@end
