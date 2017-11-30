//
//  YLWebBrowser.m
//  YLWebBrowser
//
//  Created by Yunpeng on 2016/12/20.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKWebBrowser.h"
#import "UINavigationController+LKShouldPop.h"
#import <objc/runtime.h>
#import "AppContext.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "FLAnimatedImage.h"
#import "TBActionSheet.h"
#import <Photos/Photos.h>
#import "UIImage+LKExpansion.h"
#import "UIView+LKTools.h"
#import "Foundation+LKTools.h"
#import "AppMediator.h"
// 以下耦合是为了保证兼容性
#import "RTRootNavigationController.h"

static NSString * const kJSRemoveTouchOfImages =
        @"var objs = document.getElementsByTagName(\"img\");"
        "for(var i=0;i < objs.length;i++) {"
            "objs[i].style.webkitUserSelect = 'none';"
            "objs[i].style.webkitTouchCallout = 'none';"
        "};";

static NSString * const kJSFetchTouchedImageRectFunc =
    @"function fetchTouchedImageRect(x, y) {"
        "var img = document.elementFromPoint(x, y);"
        "var rect = img.getBoundingClientRect();"
        "return \"{{\" + rect.left + \",\" + rect.top + \"}, {\" + img.width + \",\" + img.height  + \"}}\";"
    "};";

static NSString * const kJSFetchCookieFunc =
    @"function fetchCookieByName(name) {"
        "var value = \"; \" + document.cookie;"
        "var parts = value.split(\"; \" + name + \"=\");"
        "if (parts.length == 2) {"
            "return parts.pop().split(\";\").shift();"
        "}"
     "};";

NSString *JSTouchedImage(CGPoint point) {
    return [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
}

NSString *JSTouchedImageRect(CGPoint point) {
    return [NSString stringWithFormat:@"fetchTouchedImageRect(%f, %f)", point.x, point.y];
}

NSString *JSCookieValueForKey(NSString *name) {
    return [NSString stringWithFormat:@"fetchCookieByName(\"%@\")", name];
}


#define RootViewWidth self.view.frame.size.width
#define RootViewHeight self.view.frame.size.height

NSString * const kBlankURLString = @"about:blank";
#define kYLHostTextFormat @"网页由 %@ 提供"

@interface LKWebBrowser () <UIGestureRecognizerDelegate,LKBackButtonHandlerProtocol> {
    BOOL _firstLoad;
}
@property (nonatomic, strong) WKWebView *webView;
@property (strong, nonatomic) UILabel *hostTextLabel;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong) NSUserActivity *userActivity;

@end

@implementation LKWebBrowser
- (instancetype)initWithURL:(NSURL *)url {
    self = [self initWithURL:url title:nil];
    if (self) {
        self.webpageTitleEnable = YES;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        self.URL = url;
        self.webpageTitleEnable = NO;
        self.handoffEnable = YES;
//        self.isLoadRequestAfterInit = YES;
        self.moreEnable = YES;
        self.title = title;
        self.hidesBottomBarWhenPushed = YES;
        self.closeButtonEnable = YES;
        self.maskEnable = YES;
        _firstLoad = YES;
    }
    return self;
}

+ (instancetype)webBrowserWithURL:(NSURL *)url {
    return [[LKWebBrowser alloc] initWithURL:url];
}

+ (instancetype)webBrowserWithURL:(NSURL *)url title:(NSString *)title {
    return [[LKWebBrowser alloc] initWithURL:url title:title];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self.view addSubview:self.webView];
    [self.webView insertSubview:self.hostTextLabel belowSubview:self.webView.scrollView];
    
    self.hostTextLabel.text = [NSString stringWithFormat:kYLHostTextFormat, self.URL.host];
    [self.view addSubview:self.progressView];
    
    [self reloadWebView];
    
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIColor *tintColor = self.navTintColor;
    if(tintColor != nil) {
        NSLog(@"设置背景颜色, %@",[tintColor hexValue]);
        navBar.translucent = YES;
        [navBar lt_setBackgroundColor:tintColor];
        UIColor *contColor = ContrastColor(tintColor, NO);
        [navBar setTintColor:contColor];
        [navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:contColor }];
    } else {
        [navBar setTintColor:[UIColor whiteColor]];
        [navBar lt_setBackgroundColor:LKColorLightBlue];
    }
    
    
    if(self.maskEnable) {
        [self.webView addSubview:self.maskView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // stop video or audio when quit
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kBlankURLString]]];
}

#pragma mark - BackButtonHandlerProtocol

- (BOOL)navigationShouldPopOnBackButton {
    if (self.webView.allowsBackForwardNavigationGestures && self.webView.canGoBack) {
        [self.webView goBack];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - setup
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.navTintColor == nil) {
        return UIStatusBarStyleLightContent;
    }
    UIColor *color = [UIColor colorWithContrastingBlackOrWhiteColorOn:self.navTintColor isFlat:NO];
    if ([[color hexValue] isEqualToString:@"#FFFFFF"]) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网页消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网页消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网页消息" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
    NSLog(@"%@",webView.loading?@"加载中":@"未加载");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.loading = YES;
    
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressView.frame;
        frame.size.width = 0.7 * RootViewWidth;
        self.progressView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.loading) {
            [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect frame = self.progressView.frame;
                frame.size.width = 0.9 * RootViewWidth;
                self.progressView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);

    NSLog(@"%@",webView.loading?@"加载中":@"未加载");
    
    [self fixGesturesBug];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.loading = NO;
    self.hostTextLabel.text = [NSString stringWithFormat:kYLHostTextFormat, webView.URL.host];
    
    // set up title
    
    if (self.webpageTitleEnable) {
        NSString *title = webView.title;
        if (title.length >9) {
            title = [[title substringToIndex:9] stringByAppendingString:@"…"];
        }
        self.title = title;
    }
    
    // set up handoff
    if (self.handoffEnable) {
        self.userActivity.webpageURL = webView.URL;
        [self.userActivity becomeCurrent];
    }
    
    NSString *kJSAdCleaner = [self AdCleanerJSForHost:webView.URL.host];
    if (kJSAdCleaner) {
        [webView evaluateJavaScript:kJSAdCleaner completionHandler:nil];
    }
    
    
    if (self.moreEnable) {
        @weakify(self);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_more_item_normal"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            @strongify(self);
            
            LKSharePanel *panel = [[LKSharePanel alloc] initWithShareModel:self.shareModel];
            panel.title = self.hostTextLabel.text;
            [panel addLine:self.basicWebPanelLine];
            [panel show];
            
        }];
    }
    
    
    if(self.maskEnable && !self.maskDelayEnable) {
        [self hiddenMaskView];
    }
    
    [self.progressView.layer removeAllAnimations];
    self.progressView.frame = self.progressView.layer.presentationLayer.frame;
    CGFloat duration = self.progressView.frame.size.width > RootViewWidth * 0.5 ? 0.5 : 1.0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressView.frame;
        frame.size.width = RootViewWidth;
        self.progressView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.maskEnable && self.maskDelayEnable) {
            [self hiddenMaskView];
        }
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressView.alpha = 0;
        } completion:^(BOOL finished) {
            CGRect frame = self.progressView.frame;
            frame.size.width = 0;
            self.progressView.frame = frame;
            self.progressView.alpha = 1;
            [self fixGesturesBug];
        }];
    }];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}


- (void)fixGesturesBug {
    // show closeBarButtonItem
    // fix sometime 'webView.allowsBackForwardNavigationGestures = YES' excute not correct
    
    if(self.webView.allowsBackForwardNavigationGestures) {
        if (self.webView.canGoBack) {
            self.rt_disableInteractivePop = YES;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            if (self.closeButtonEnable) {
                [self.navigationItem setLeftBarButtonItems:@[self.closeBarButtonItem] animated:NO];
            }
        } else {
            if (![self.navigationController isMemberOfClass:[UINavigationController class]]) {
                self.rt_disableInteractivePop = NO;
            } else {
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
            
            [self.navigationItem setLeftBarButtonItems:nil];
        }
    }
}

- (NSString *)AdCleanerJSForHost:(NSString *)host {
    
    static NSDictionary *adCleanerDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AdCleanerJS" ofType:@"plist"];
        adCleanerDict = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    NSLog(@"[%s] host: %@ JS:%@",__func__, host, adCleanerDict[host]);
    return adCleanerDict[host];
}


- (void)hiddenMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        self.maskView.alpha = 1;
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
   
}

#pragma mark redirect

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSLog(@"[%s],%@",__func__, url.absoluteString);
    
    if ([url.absoluteString hasPrefix:@"https://itunes.apple.com"]
        && [[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"即将离开西交Link，\n跳转至App Store" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:url];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (![url.scheme isEqualToString:@"http"]
        && ![url.scheme isEqualToString:@"https"]) {
        [[AppMediator sharedInstance] performActionWithURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;

    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - Public API
- (void)clearCacheAndCookies {
    _firstLoad = YES;
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        NSLog(@"WKWebView清除缓存完成");
    }];
}
- (void)reloadWebView {
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:self.URL];
    if (_firstLoad) {
        [request setHTTPShouldHandleCookies:YES];
        NSMutableString *cookieString = [[NSMutableString alloc] init];
        [self.cookies enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cookieString appendFormat:@"%@=%@;",key ,obj];
        }];
        [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
        _firstLoad = NO;
    }
    [self.webView loadRequest:request];
}


- (void)fetchCookieValueForKey:(NSString *)key completionHandler:(void (^)(NSString *cookie))completionHandler {
    [self.webView evaluateJavaScript:JSCookieValueForKey(key) completionHandler:^(NSString *cookie, NSError * _Nullable error) {
        if (cookie != nil
            && ![cookie isEqualToString:@""]) {
            completionHandler(cookie);
        } else {
            completionHandler(nil);
        }
    }];
}

#pragma mark - Private API

- (void)closeBarButtonItemDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchImageFromWebViewAtPoint:(CGPoint)point completionHandler:(void (^)(NSString *imageURLString))handler {
    [self.webView evaluateJavaScript:JSTouchedImage(point)
                   completionHandler:^(NSString *imageURLString, NSError * _Nullable error) {
        imageURLString = [imageURLString stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (imageURLString != nil
            && ![imageURLString isEqualToString:@""]) {
            handler(imageURLString);
        } else {
            handler(nil);
        }
    }];
}


#pragma mark - 手势
- (void)longPressGestureRecognizerHandler:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return; // 防止多次执行
    }
    NSLog(@"%s",__func__);
    
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    [self fetchImageFromWebViewAtPoint:touchPoint completionHandler:^(NSString *touchedImage) {
        NSLog(@"touchedImage:%@",touchedImage);
        if (touchedImage != nil) {
            [self.webView evaluateJavaScript:JSTouchedImageRect(touchPoint) completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                CGRect rect = CGRectFromString(obj);
                NSURL *url = [NSURL URLWithString:touchedImage];
                [self longPressOnImageWithURL:url atRect:rect];
                if([self.delegate respondsToSelector:@selector(yl_webBrowser:longPressOnImageWithURL:)]) {
                    [self.delegate yl_webBrowser:self longPressOnImageWithURL:url];
                }
            }];
        }
    }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)longPressOnImageWithURL:(NSURL *)url atRect:(CGRect)rect {

    TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
    
    
    NSString *scanResult = nil;
    @try {
        UIImage *srcImage = [[self.webView lk_imageSnapshot] lk_imageForRect:rect];
        CIContext *context = [CIContext contextWithOptions:nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
        NSArray *features = [detector featuresInImage:image];
        CIQRCodeFeature *feature = [features firstObject];
        scanResult = feature.messageString;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    @weakify(self);
    if ([NSString notBlank:scanResult]) {
        [actionSheet addButtonWithTitle:@"识别图中二维码" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            @strongify(self);
            TBActionSheet *textActionSheet = [[TBActionSheet alloc] init];
            textActionSheet.title = scanResult;
            
            NSURL *url = [NSURL URLWithString:scanResult];
            if(url != nil
               && ([url.scheme isEqualToString:@"http"]
                   || [url.scheme isEqualToString:@"https"])
               ) {
                [textActionSheet addButtonWithTitle:@"打开" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
                    LKWebBrowser *browser = [[LKWebBrowser alloc] initWithURL:url];
                    [self.navigationController pushViewController:browser animated:YES];
                }];
            }
            
            [textActionSheet addButtonWithTitle:@"复制" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
                [UIPasteboard generalPasteboard].string = scanResult;
                [AppContext showProgressHUDWithMessage:@"已复制" image:[UIImage imageNamed:@"hud_icon_checkmark"]];
            }];
            [textActionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
            [textActionSheet show];
        }];
    }
    
    [actionSheet addButtonWithTitle:@"保存图片" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        [AppContext showProgressLoadingWithMessage:@"正在保存"];
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [AppContext showProgressFinishHUDWithMessage:@"保存成功"];
                } else {
                    [AppContext showProgressFailHUDWithMessage:@"保存失败，请检查相册访问权限。"];
                }
            }];
            
        }];
        
        
    }];
    
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}


- (void)dealloc {
    
}


#pragma mark - 3D Touch

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *copy = [UIPreviewAction actionWithTitle:@"复制链接" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [UIPasteboard generalPasteboard].string = self.URL.absoluteString;
        [AppContext showProgressHUDWithMessage:@"已复制" image:[UIImage imageNamed:@"hud_icon_checkmark"]];
    }];
    
    UIPreviewAction *openInSafari = [UIPreviewAction actionWithTitle:@"在Safari中打开" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSURL *url = [NSURL URLWithString:self.shareModel.url];
        [[UIApplication sharedApplication] openURL:url];
    }];
    NSArray *items = @[copy,openInSafari];
    return items;
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (_webView == nil) {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MainViewSize.width, MainViewSize.height)];
        
        _webView.backgroundColor =
            [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        _webView.opaque = NO;
        _webView.allowsLinkPreview = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.allowsBackForwardNavigationGestures = YES;
        
        WKUserContentController *userContentController = _webView.configuration.userContentController;
        
        WKUserScript *removeTouchOfImages = [[WKUserScript alloc] initWithSource:kJSRemoveTouchOfImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:removeTouchOfImages];
        
        WKUserScript *fetchTouchedImageRect = [[WKUserScript alloc] initWithSource:kJSFetchTouchedImageRectFunc injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:fetchTouchedImageRect];
        
        WKUserScript *fetchCookieFunc = [[WKUserScript alloc] initWithSource:kJSFetchCookieFunc injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:fetchCookieFunc];
        
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandler:)];
        longPress.minimumPressDuration = 0.25;
        longPress.delegate = self;
        [self.webView addGestureRecognizer:longPress];
    }
    return _webView;
}


- (UIBarButtonItem*)closeBarButtonItem{
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonItemDidClicked:)];
    }
    return _closeBarButtonItem;
}

- (UILabel *)hostTextLabel {
    if (_hostTextLabel == nil) {
        _hostTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
        _hostTextLabel.font = [UIFont systemFontOfSize:12];
        _hostTextLabel.textColor = [UIColor grayColor];
        _hostTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hostTextLabel;
}

- (UIView *)progressView {
    if (_progressView == nil) {
        CGRect frame = CGRectMake(0, 0, 0, 2.5);
        _progressView = [[UIView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _progressView.backgroundColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
    }
    return _progressView;
}


- (NSUserActivity *)userActivity {
    if (_userActivity == nil) {
        _userActivity = [[NSUserActivity alloc]initWithActivityType:NSUserActivityTypeBrowsingWeb];
    }
    return _userActivity;
}

- (YLAlertPanelLine *)basicWebPanelLine {
    if (_basicWebPanelLine == nil) {
        _basicWebPanelLine = [[YLAlertPanelLine alloc] init];
        //            [line addButtonWithTitle:@"收藏" image:[UIImage imageNamed:@"option_icon_collect"] handler:^(YLAlertPanelButton *button) {
        //
        //            }];
        @weakify(self);
        [_basicWebPanelLine addButtonWithTitle:@"复制链接" image:[UIImage imageNamed:@"option_icon_copy"] handler:^(YLAlertPanelButton *button) {
            @strongify(self);
            [UIPasteboard generalPasteboard].string = self.URL.absoluteString;
            [AppContext showProgressHUDWithMessage:@"已复制" image:[UIImage imageNamed:@"hud_icon_checkmark"]];
        }];
        
        [_basicWebPanelLine addButtonWithTitle:@"刷新" image:[UIImage imageNamed:@"option_icon_refresh"] handler:^(YLAlertPanelButton *button) {
            @strongify(self);
            [self reloadWebView];
        }];
    }
    return _basicWebPanelLine;
}

- (LKShareModel *)shareModel {
    if (_shareModel == nil) {
        _shareModel = [LKShareModel new];
        _shareModel.title =  self.webView.title?:self.title;
        _shareModel.summary = @"分享来自西交Link";
        _shareModel.url = [self.URL absoluteString];
        _shareModel.image = ShareModelDefaultImage;
    }
    return _shareModel;
}

- (NSMutableDictionary *)cookies {
    if (_cookies == nil) {
        _cookies = [[NSMutableDictionary alloc] init];
    }
    return _cookies;
}


- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.webView.frame];
        _maskView.backgroundColor = [UIColor whiteColor];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading_rubik" ofType:@"gif"];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:path]];
        FLAnimatedImageView *loadingView = [[FLAnimatedImageView alloc] init];
        loadingView.animatedImage = image;
        loadingView.frame = CGRectMake(0.0, 0.0, MainScreenSize.width, MainScreenSize.width / 1.19);
        loadingView.center = CGPointMake(MainScreenSize.width/ 2,MainScreenSize.height /2 - 64);
        
        [_maskView addSubview:loadingView];
        
    }
    return _maskView;
}
@end
