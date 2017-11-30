//
//  Macros.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#import "Constants.h" // 防止导入这个头文件前没有导入Constants.h
#import "ColorMacros.h"
#import "LKTranscoder.h"

#import <UIKit/UIApplication.h>

#define MainViewSize self.view.frame.size
#define MainViewFrame self.view.frame

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define LKUserDefaults [NSUserDefaults standardUserDefaults]

#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 相关文件路径
#define kUserCacheFileName [[NSString stringWithFormat:@"link.xjtu.cache.v.%@",AppCacheVersion] md5String]
#define kCourseCacheFileName [[NSString stringWithFormat:@"link.xjtu.course.cache.v.%@",AppCacheVersion] md5String]
#define kLibraryCacheFileName [[NSString stringWithFormat:@"link.xjtu.library.cache.v.%@",AppCacheVersion] md5String]
#define kTranscriptsCacheFileName [[NSString stringWithFormat:@"link.xjtu.transcripts.cache.v.%@",AppCacheVersion] md5String]
#define kScheduleCacheFileName [[NSString stringWithFormat:@"link.xjtu.schedule.cache.v.%@",AppCacheVersion] md5String]

#define _NSSearchPathForDirectoriesInDomains(TYPE) \
[NSSearchPathForDirectoriesInDomains(TYPE, NSUserDomainMask, YES) firstObject]

#define AppCachePath _NSSearchPathForDirectoriesInDomains(NSCachesDirectory)
#define AppDocumentPath _NSSearchPathForDirectoriesInDomains(NSDocumentDirectory)


////////////////////////////////////////////////////////////////////////////////////////////////////////

#define async_execute(BLOCK) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), BLOCK)

#define async_execute_before_resign_active(BLOCK) \
static dispatch_once_t lk_resign_active_onceToken;\
dispatch_once(&lk_resign_active_onceToken, ^{\
    [[NSNotificationCenter defaultCenter]\
     addObserverForName:UIApplicationWillResignActiveNotification\
     object:nil queue:nil\
     usingBlock:^(NSNotification * _Nonnull note) {\
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), BLOCK);\
     }];\
})


#define execute_after_launching_on_main_queue(BLOCK) \
    static dispatch_once_t lk_after_launching_onceToken;\
    dispatch_once(&lk_after_launching_onceToken, ^{\
    [[NSNotificationCenter defaultCenter]\
    addObserverForName:UIApplicationDidFinishLaunchingNotification\
    object:nil queue:nil\
    usingBlock:^(NSNotification * _Nonnull note) {\
        dispatch_async(dispatch_get_main_queue(),BLOCK);\
    }];\
})

#define async_execute_after_launching(BLOCK) \
static dispatch_once_t lk_after_launching_onceToken;\
    dispatch_once(&lk_after_launching_onceToken, ^{\
    [[NSNotificationCenter defaultCenter]\
    addObserverForName:UIApplicationDidFinishLaunchingNotification\
    object:nil queue:nil\
    usingBlock:^(NSNotification * _Nonnull note) {\
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), BLOCK);\
    }];\
})


#endif /* Macros_h */
