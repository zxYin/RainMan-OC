//
//  LKShareManager.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKShareModel.h"
#import <UIKit/UIKit.h>

extern NSString * const LKShareToSafari;
extern NSString * const LKShareActionNotCollect;
extern NSString * const LKShareActionCollected;
extern NSString * const LKShareActionAccessory;

typedef NS_ENUM(NSInteger,LKSharePlatformType) {
    kSharePlatformTypeSina         = 0,    //新浪
    kSharePlatformTypeWechat       = 1,    //微信聊天
    kSharePlatformTypeWXMoments    = 2,    //微信朋友圈
    kSharePlatformTypeQQ           = 4,    //QQ聊天页面
    kSharePlatformTypeQzone        = 5,    //qq空间
    kSharePlatformTypeSafari       = 3001, //Safari
};


@class LKShareManager;
@protocol LKShareManagerDelegate <NSObject>
@optional
- (void)shareManager:(LKShareManager *)manager didSelectShareAction:(NSString *)action;
- (NSArray *)shareManagerExternActions;
@end

@interface LKShareManager : NSObject
//+ (void)setup;
+ (instancetype)sharedInstance;

- (void)shareWithModel:(LKShareModel *)model platform:(NSInteger)platform;

- (BOOL)handleOpenURL:(NSURL *)url;

//- (void)shareWithModel:(LKShareModel *)model at:(UIViewController *)vc;
//- (void)shareWithModel:(LKShareModel *)model at:(UIViewController *)vc delegate:(id<LKShareManagerDelegate>)delegate;

- (BOOL)isInstall:(NSInteger)platform;
@end

