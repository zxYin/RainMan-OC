//
//  YLWebBrowser.h
//  YLWebBrowser
//
//  Created by Yunpeng on 2016/12/20.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "LKSharePanel.h"

extern NSString * const kBlankURLString;

@class LKWebBrowser;
@protocol YLWebBrowserDelegate<NSObject>
@optional
- (void)yl_webBrowser:(LKWebBrowser *)browser longPressOnImageWithURL:(NSURL *)url;
// thumbnailImage:(UIImage *)image;
@end


@interface LKWebBrowser : UIViewController<WKNavigationDelegate, WKScriptMessageHandler,WKUIDelegate>
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) NSURL *URL;

// Browser's title will be set with webpage's title if webpageTitleEnable is YES
@property (nonatomic, assign) BOOL webpageTitleEnable;
@property (nonatomic, assign) BOOL handoffEnable; // default is YES
@property (nonatomic, assign) BOOL closeButtonEnable;

@property (assign, nonatomic, getter=isLoading) BOOL loading;

@property (nonatomic, strong) UIColor *navTintColor;
@property (nonatomic, strong) NSMutableDictionary *cookies;
@property (nonatomic, strong) YLAlertPanelLine *basicWebPanelLine;
@property (nonatomic, strong) LKShareModel *shareModel;
@property (nonatomic, assign) BOOL moreEnable;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) BOOL maskEnable;
@property (nonatomic, assign) BOOL maskDelayEnable; //用于注入JS防止突变 // default is NO


@property (nonatomic, weak) id<YLWebBrowserDelegate> delegate;


- (void)clearCacheAndCookies;

- (void)reloadWebView;


- (void)fetchCookieValueForKey:(NSString *)key completionHandler:(void (^)(NSString *cookie))completionHandler;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title;
+ (instancetype)webBrowserWithURL:(NSURL *)url;
+ (instancetype)webBrowserWithURL:(NSURL *)url title:(NSString *)title;


- (void)longPressOnImageWithURL:(NSURL *)url;
@end
