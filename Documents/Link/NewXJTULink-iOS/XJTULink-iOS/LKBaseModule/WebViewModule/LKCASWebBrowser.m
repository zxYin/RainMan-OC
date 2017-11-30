//
//  LKCASWebBrowser.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKCASWebBrowser.h"
#import "User+Auth.h"
#import "YLTokenRefresher.h"
#import "NSDictionary+LKValueGetter.h"
#import "Macros.h"
#import "Foundation+LKTools.h"
@interface LKCASWebBrowser ()
@end

@implementation LKCASWebBrowser
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    self = [super initWithURL:url title:title];
    if (self) {
        self.moreEnable = NO;
        self.handoffEnable = NO;
        [self clearCacheAndCookies];
        [self setupCASCookies];
    }
    return self;
}

+ (LKCASWebBrowser *)webBrowserWithURL:(NSURL *)url title:(NSString *)title {
    return [[self alloc] initWithURL:url title:title];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *url = webView.URL.absoluteString;
    if ([url hasPrefix:kCASURL]) {
        NSLog(@"[WKWebView]需登录");
        async_execute(^{
            YLTokenRefresher *refresher = [YLTokenRefresher sharedInstance];
            [refresher needRefresh];
            dispatch_semaphore_wait(refresher.continueMutex, DISPATCH_TIME_FOREVER);
            // 得到后立刻释放，防止其他请求无法进行
            dispatch_semaphore_signal(refresher.continueMutex);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self clearCacheAndCookies];
                [self setupCASCookies];
                [self reloadWebView];
            });
        });
    } else {
        [super webView:webView didFinishNavigation:navigation];
    }
}

#pragma mark - Private API
- (void)setupCASCookies {
    NSString *castgc = [[User sharedInstance] unencryptedNewRequestToken];
    // 这里优先取新token
    if ([NSString isBlank:castgc]) {
        castgc = [[User sharedInstance] unencryptedRequestToken];
    }
    self.cookies[@"CASTGC"] = castgc;

}

@end
