//
//  Constants.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import "NotificationConstants.h"
#import "LKTranscoder.h"
#import "DynamicConfig.h"

static NSString * const AppCacheVersion = @"2.4.0";
static NSString * const AppStorePath = @"itms-apps://itunes.apple.com/app/id1054815570";

static NSString * const AppScheme = @"xjtulink";

//static NSString * const kServerURL = @"https://xjtu.link/api";

static NSString * const kCASURL = @"https://cas.xjtu.edu.cn/";
static NSString * const kLinkWeiboURL = @"http://weibo.com/u/5688641363";
static NSString * const kLinkMail = @"support@xjtu.link";

#define KeychainKeyToken [@"link.xjtu.key@userToken" md5String]
#define KeychainKeyNetId [@"link.xjtu.key@netId" md5String]
#define KeychainKeyPassword [@"link.xjtu.key@password" md5String]
#define KeychainKeyLibraryUsername  [@"link.xjtu.key@libraryUsername" md5String]
#define KeychainKeyLibraryPassword  [@"link.xjtu.key@libraryPassword" md5String]

#define KeychainKeyAccount(ACCOUNT) [[NSString stringWithFormat:@"link.xjtu.key@account.%@", ACCOUNT]  md5String]

static NSString * const XJTULinkSharedDefaults = @"group.XJTULinkSharedDefaults";

typedef NS_ENUM(NSInteger, PageShowType) {
    kPageShowTypeNative,
    kPageShowTypeWeb,
};


static NSString * const kClubTypeKeyTitle = @"kClubTypeKeyTitle";
static NSString * const kClubTypeKeyImage = @"kClubTypeKeyImage";
static NSString * const kClubTypeKeyId = @"kClubTypeKeyId";

static NSString * const kLocalNotificationURL = @"kLocalNotificationURL";
static NSString * const kLocalNotificationKey = @"kLocalNotificationKey";




#import "VendorConstants.h"
#import "UserDefaultsConstants.h"
#endif /* Constants_h */
