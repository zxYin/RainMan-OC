//
//  UserDefaultsConstants.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef UserDefaultsConstants_h
#define UserDefaultsConstants_h
#import "LKTranscoder.h"

static NSString * const kUserDefaultsAcademyList = @"kUserDefaultsAcademyList";
static NSString * const kUserDefaultsCurrentWeek = @"kUserDefaultsCurrentWeek";
static NSString * const LKUserDefaultsShouldCheckNoticationPermission = @"kUserDefaultsShouldCheckNoticationPermission";
static NSString * const LKUserDefaultsFirstEnterLibrary = @"LKUserDefaultsFirstEnterLibrary";
static NSString * const LKUserDefaultsFirstEnterCommunity = @"LKUserDefaultsFirstEnterCommunity";
static NSString * const LKUserDefaultsFirstEnterMessage = @"LKUserDefaultsFirstEnterMessage";


#define LKUserDefaultsDebugMode [@"link.xjtu.LKUserDefaultsDebugMode" md5String]

#define LKUserDefaultsFirstLaunch [[NSString stringWithFormat:@"FirstLaunch-Vertion.%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] md5String]

#define LKUserDefaultsNewVersionLastAlert [@"link.xjtu.LKUserDefaultsNewVersionLastAlert" md5String]
#define LKUserDefaultsSkipVersions [@"link.xjtu.LKUserDefaultsSkipVersions" md5String]
#define LKUserDefaultsForceLogin [@"link.xjtu.LKUserDefaultsForceLogin" md5String]
#define LKUserDefaultsFPS [@"link.xjtu.LKUserDefaultsFPS" md5String]
#define LKUserDefaultsDeviceToken [@"link.xjtu.LKUserDefaultsDeviceToken" md5String]

#endif /* UserDefaultsConstants_h */
