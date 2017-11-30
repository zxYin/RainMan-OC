//
//  LKShareManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKShareManager.h"
#import "VendorConstants.h"
#import <UMSocialCore/UMSocialCore.h>
#import "Macros.h"
//typedef void (^LKShareManagerButtonHandler)(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController);

NSString * const LKShareToSafari = @"LKShareToSafari";
NSString * const LKShareActionNotCollect = @"LKShareActionNotCollect";
NSString * const LKShareActionCollected = @"LKShareActionCollected";
NSString * const LKShareActionAccessory = @"LKShareActionAccessory";

@interface LKShareManager()
@property (nonatomic, strong) NSMutableArray *platforms;
@property (nonatomic, copy) NSString *currentURL;
@property (nonatomic, weak) id<LKShareManagerDelegate> currentDelegate;
@end

@implementation LKShareManager
#pragma mark - 初始化
+ (void)load {
    async_execute_after_launching(^{
#ifdef DEBUG
        [[UMSocialManager defaultManager] openLog:YES];
#endif
        [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
        
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                              appKey:@"wx8e8fe99e4f5b5c5c"
                                           appSecret:@"23522cd68e7299cbe4f8111f2a895072"
                                         redirectURL:@"http://link.xjtu.edu.cn"];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                              appKey:@"1105255021"
                                           appSecret:@"1MFjoPgfsTSy7dcY"
                                         redirectURL:@"http://link.xjtu.edu.cn"];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                              appKey:@"2930968147"
                                           appSecret:@"68bf4b65e9b81318fbc47aac6a15291f"
                                         redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        
        NSLog(@"[组件初始化]分享组件初始化完成");
    });
}

//+ (void)setup {
//    async_execute(^{
//
//    });
//}


+ (void)callback:(NSString *)action {
    LKShareManager *manager = [LKShareManager sharedInstance];
    if ([manager.currentDelegate respondsToSelector:@selector(shareManager:didSelectShareAction:)]) {
        [manager.currentDelegate shareManager:manager didSelectShareAction:action];
    }
}

#pragma mark -
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKShareManager alloc] init];
    });
    return instance;
}


#pragma mark - Public API

- (void)shareWithModel:(LKShareModel *)model platform:(NSInteger)platform {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:model.summary thumImage:model.image];
    shareObject.webpageUrl = model.url;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
    
    
}
- (BOOL)handleOpenURL:(NSURL *)url {
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (NSString *)currentURL {
    if (_currentURL == nil) {
        _currentURL = @"http://link.xjtu.edu.cn";
    }
    return _currentURL;
}


- (BOOL)isInstall:(NSInteger)platform {
    return [[UMSocialManager defaultManager] isInstall:platform];
}
@end
