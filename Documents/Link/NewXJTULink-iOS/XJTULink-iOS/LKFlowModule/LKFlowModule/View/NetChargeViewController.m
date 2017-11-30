//
//  NetChargeViewController.m
//  LKFlowModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NetChargeViewController.h"
#import "Constants.h"
static NSString * kPreTransferURL = @"https://cas.xjtu.edu.cn/login?service=http://card.xjtu.edu.cn:8070/Account/CASLogin";
static NSString * kNetChargeURL = @"http://card.xjtu.edu.cn:8070/AutoPay/NetFee/Index";
@interface NetChargeViewController ()

@end

@implementation NetChargeViewController
- (instancetype)init {
    self = [super initWithURL:[NSURL URLWithString:kPreTransferURL] title:@"缴网费"];
    if (self) {
        self.maskDelayEnable = YES;
        self.closeButtonEnable = NO;
    }
    return self;
}

// 覆盖此方法，确保安全
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    return [self init];
}

+ (LKCASWebBrowser *)webBrowserWithURL:(NSURL *)url title:(NSString *)title {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKUserScript *netchargejs = [[WKUserScript alloc] initWithSource:[self netchargejs] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:netchargejs];
    self.webView.allowsBackForwardNavigationGestures = NO;
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *url = webView.URL.absoluteString;
    NSLog(@"[%s] url = %@",__func__, url);
    if (![url isEqualToString:kBlankURLString]
        && ![url isEqualToString:kNetChargeURL]
        && ![url hasPrefix:kCASURL]) {
        self.URL = [NSURL URLWithString:kNetChargeURL];
        [self reloadWebView];
    } else {
        [super webView:webView didFinishNavigation:navigation];
    }
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [super webViewDidFinishLoad:webView];
//    if(self.isLoading) return;
//    
//    NSString *url = webView.request.URL.absoluteString;
//    if (
//        ![url isEqualToString:kYLBlankURL]
//        &&
//        ![url isEqualToString:kNetChargeURL]) {
//        
//        [self reloadWebView];
//        return;
//    }
//    [self webpageDidLoad];
//}

- (BOOL)shouldPageDidLoad {
    return NO;
}

- (NSString *)netchargejs {
    return @"var nmeta = document.createElement('meta');nmeta.content = 'telephone=no,user-scalable=no';nmeta.name = 'format-detection';document.getElementsByTagName('head')[0].appendChild(nmeta);var page = document.body.getElementsByTagName('div')[0];page.style.paddingTop = 0;page.style.paddingBottom = 0;page.style.height=\"100%\";var divs = page.getElementsByTagName('div');var header = divs[0];var footer = divs[divs.length-1];header.style.visibility='hidden';footer.style.visibility='hidden';header.parentNode.removeChild(header);footer.parentNode.removeChild(footer);document.getElementById('txtAmount').pattern='[0-9]*';document.getElementById('Password').pattern='[0-9]*';document.documentElement.style.webkitUserSelect='none';";
}

@end
