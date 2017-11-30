//
//  TransferViewController.m
//  LKCardModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TransferViewController.h"
#import "Constants.h"
#import "ViewsConfig.h"
static NSString * kPreTransferURL = @"https://cas.xjtu.edu.cn/login?service=http://card.xjtu.edu.cn:8070/Account/CASLogin";

static NSString * kTransferURL = @"http://card.xjtu.edu.cn:8070/SynCard/Manage/Transfer";
@interface TransferViewController ()

@end

@implementation TransferViewController
- (instancetype)init {
    self = [super initWithURL:[NSURL URLWithString:kPreTransferURL] title:@"在线圈存"];
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
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_help_icon_normal"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        LKWebBrowser *vc =
        [[LKWebBrowser alloc] initWithURL:[NSURL URLWithString:@"https://link.xjtu.edu.cn/web/help/class/1/"] title:@"圈存帮助"];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    
    UIImage *image = [UIImage imageNamed:@"image_transfer_guide"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(MainScreenSize.width - 160 - 10, 5, 160, 100);
    [self.maskView addSubview:imageView];
    
    
    WKUserScript *transferjs = [[WKUserScript alloc] initWithSource:[self transferjs] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:transferjs];
    self.webView.allowsBackForwardNavigationGestures = NO;
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *url = webView.URL.absoluteString;
    if (![url isEqualToString:kBlankURLString]
        && ![url isEqualToString:kTransferURL]
        && ![url hasPrefix:kCASURL]) {
        self.URL = [NSURL URLWithString:kTransferURL];
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
//        ![url isEqualToString:kTransferURL]) {
//        
//        [self reloadWebView];
//        return;
//    }
//    [self webpageDidLoad];
//}


- (BOOL)shouldPageDidLoad {
    return NO;
}

- (NSString *)transferjs {
    return @"var nmeta = document.createElement('meta');nmeta.content = 'telephone=no,user-scalable=no';nmeta.name = 'format-detection';document.getElementsByTagName('head')[0].appendChild(nmeta);var page = document.body.getElementsByTagName('div')[0];page.style.paddingTop = 0;page.style.paddingBottom = 0;page.style.height=\"100%\";var divs = page.getElementsByTagName('div');var header = divs[0];var footer = divs[divs.length-1];header.style.visibility='hidden';footer.style.visibility='hidden';header.parentNode.removeChild(header);footer.parentNode.removeChild(footer);document.getElementById('txtAmount').pattern='[0-9]*';document.getElementById('Password').pattern='[0-9]*';document.documentElement.style.webkitUserSelect='none';";
}

@end
