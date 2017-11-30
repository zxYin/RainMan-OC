//
//  LKNoticeManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKNoticeManager.h"
#import "Macros.h"
#import "Foundation+LKTools.h"
#import "LKNoticeAlert.h"
#import "AppMediator.h"
#import "AppContext.h"
#import "LKWebBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDictionary+LKValueGetter.h"
#import "NoticeAPIManager.h"

NSString * const LKNoticeTypeText = @"text";
NSString * const LKNoticeTypeImage = @"image";
NSString * const LKNoticeTypeConfession = @"confession";
NSString * const LKGlobalNotice = @"global";
@interface UIViewController (LKNotice)
- (void)showNoticeIfNeeded;
@end

@interface LKNoticeManager()<YLAPIManagerDelegate>
@property (nonatomic, strong) NoticeAPIManager *noticeAPIManager;
@end

@implementation LKNoticeManager
+ (void)load {
    async_execute_after_launching(^{
        [[LKNoticeManager sharedInstance].noticeAPIManager loadData];
    });
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKNoticeManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKNoticeManager alloc] init];
    });
    return instance;
}

- (void)setupTest {
    NSDictionary *noticeDict =
    @{
      @"HomeViewController" : @{
              @"uuid"       : @"23u8f7sgf732fsd2",
              @"type"       : LKNoticeTypeText,
              @"title"      : @"关于过渡余额显示调整的通知",
              @"summary"    : @"由于服务器调整，西交Link近期对App校园卡功能进行改动，调整如下：过渡余额服务不再支持。由于服务器调整，西交Link近期对App校园卡功能进行改动，调整如下：过渡余额服务不再支持。",
              @"url"        : @"http://e.xiumi.us/board/v5/2idJi/26190344",
              @"page_title" : @"临时通知",
              
              },
      
      @"CourseTableViewController" : @{
              @"uuid"       : @"2fwr23sgf732fse3",
              @"type"       : LKNoticeTypeImage,
              @"url"        : @"http://e.xiumi.us/board/v5/2idJi/26190344",
              @"image"      : @"https://xjtu.link/static/club_image/111_MDbzJGL.jpg",
              
              },
      };
    self.notices = [noticeDict copy];
}

- (void)showNoticeWithTitle:(NSString *)title summary:(NSString *)summary url:(NSURL *)url pageTitle:(NSString *)pageTitle {
    LKTextAlertView *contentView =
    [LKTextAlertView viewWithBlock:^{
        if ([url.scheme isEqualToString:AppScheme]) {
            [[AppMediator sharedInstance] performActionWithURL:url];
        } else {
            LKWebBrowser *vc = [LKWebBrowser webBrowserWithURL:url title:pageTitle];
            [[[AppContext sharedInstance] currentNavigationController] pushViewController:vc animated:YES];
        }
    }];
    
    contentView.titleLabel.text = title;
    contentView.contentLabel.text = summary;
    LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
    [alert show];
}

- (void)showNoticeWithImageURL:(NSURL *)imageURL url:(NSURL *)url pageTitle:(NSString *)pageTitle {
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        LKImageAlertView *contentView =
        [LKImageAlertView viewWithBlock:^{
            if ([url.scheme isEqualToString:AppScheme]) {
                [[AppMediator sharedInstance] performActionWithURL:url];
            } else {
                LKWebBrowser *vc = [LKWebBrowser webBrowserWithURL:url title:pageTitle];
                [[[AppContext sharedInstance] currentNavigationController] pushViewController:vc animated:YES];
            }
        }];
        contentView.imageView.image = image;
        CGRect frame = contentView.frame;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize contentSize = image.size;
        if (image.size.width > 2.0 * screenSize.width / 3.0) {
            CGFloat width = 2.0 * screenSize.width / 3.0;
            contentSize.height *= width / image.size.width;
            contentSize.width = width;
        }
        
        frame.size = contentSize;
        contentView.frame = frame;
        LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
        [alert show];
    }];
}

- (void)showNoticeWithImage:(UIImage *)image command:(NSURL *)command {
    LKImageAlertView *contentView =
    [LKImageAlertView viewWithBlock:^{
        [[AppMediator sharedInstance] performActionWithURL:command];
    }];
    contentView.imageView.image = image;
    CGRect frame = contentView.frame;
    frame.size = image.size;
    contentView.frame = frame;
    LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
    [alert show];
}

#pragma mark - YLAPIManagerDelegate
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    self.notices = [self.noticeAPIManager fetchData];
    [[[AppContext sharedInstance] currentViewController] showNoticeIfNeeded];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    
}


#pragma mark - getter

- (NoticeAPIManager *)noticeAPIManager {
    if (_noticeAPIManager == nil) {
        _noticeAPIManager = [[NoticeAPIManager alloc] init];
        _noticeAPIManager.delegate = self;
    }
    return _noticeAPIManager;
}
@end

@implementation UIViewController (LKNotice)
+ (void)load {
    [NSObject methodSwizzlingWithTarget:@selector(viewDidAppear:)
                                  using:@selector(swizzling_LKNotice_viewDidAppear:)
                               forClass:[self class]];
}

- (void)swizzling_LKNotice_viewDidAppear:(BOOL)animated {
    [self swizzling_LKNotice_viewDidAppear:animated];
    [self showNoticeIfNeeded];
}


- (void)showNoticeIfNeeded {
    NSDictionary *notice = [LKNoticeManager sharedInstance].notices[LKGlobalNotice];
    
    if (notice == nil) {
        NSString *clazz = NSStringFromClass([self class]);
        notice = [LKNoticeManager sharedInstance].notices[clazz];
    }
    
    if (notice != nil) {
        NSString *uuid = [notice stringForKey:@"id"];
        NSString *isPresented = [[@"link.xjtu.LKNotice." stringByAppendingString:uuid] md5String];
        
        if (![LKUserDefaults boolForKey:isPresented]) {
            NSURL *url = [notice URLForKey:@"url"];
            NSString *pageTitle = [notice stringForKey:@"page_title" defaultValue:@"Link新闻"];
            NSString *type = [notice stringForKey:@"type"];
            if ([type isEqualToString:LKNoticeTypeText]) {
                NSString *title = [notice stringForKey:@"title"];
                NSString *summary = [notice stringForKey:@"summary"];
                [[LKNoticeManager sharedInstance] showNoticeWithTitle:title summary:summary url:url pageTitle:pageTitle];
            } else if([type isEqualToString:LKNoticeTypeImage]) {
                NSURL *imageURL = [notice URLForKey:@"image"];
                [[LKNoticeManager sharedInstance] showNoticeWithImageURL:imageURL url:url pageTitle:pageTitle];
            } else if([type isEqualToString:LKNoticeTypeConfession]) {
                UIImage *image = [UIImage imageNamed:@"confession_alert"];
                NSURL *command = [notice URLForKey:@"command"];
                [[LKNoticeManager sharedInstance] showNoticeWithImage:image command:command];
            }
            
            [LKUserDefaults setBool:YES forKey:isPresented];
            
            if ([notice boolForKey:@"is_repeat"]) {
                [[NSNotificationCenter defaultCenter]
                 addObserverForName:UIApplicationDidEnterBackgroundNotification
                 object:nil queue:nil
                 usingBlock:^(NSNotification * _Nonnull note) {
                     [LKUserDefaults setBool:NO forKey:isPresented];
                 }];
            }
        }
    }

}

@end
