//
//  WebClassroomViewController.m
//  LKClassroomModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "WebClassroomViewController.h"
#import "WebClassroomAPIManager.h"
#import "ViewsConfig.h"
#import "NSDictionary+LKValueGetter.h"
#import "Foundation+LKTools.h"

@interface WebClassroomViewController () <YLAPIManagerDelegate>
@property (nonatomic, strong) WebClassroomAPIManager *webClassroomAPIManager;
@end

@implementation WebClassroomViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        self.moreEnable = NO;
        self.maskEnable = YES;
//        self.isLoadRequestAfterInit = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"空闲教室";
    [self.webClassroomAPIManager loadData];
    
    WKUserScript *wechatJS = [[WKUserScript alloc] initWithSource:[self wechatJS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:wechatJS];
    
//    self.executeJS = [self wechatJS];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if ([NSString isBlank:self.url.absoluteString]) {
//        return NO;
//    }
//}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    self.URL = [[apiManager fetchData] URLForKey:@"url"];
    [self reloadWebView];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    NSLog(@"获取地址出错");
}

- (WebClassroomAPIManager *)webClassroomAPIManager {
    if (_webClassroomAPIManager == nil) {
        _webClassroomAPIManager = [[WebClassroomAPIManager alloc] init];
        _webClassroomAPIManager.delegate = self;
    }
    return _webClassroomAPIManager;
}

- (NSString *)wechatJS {
    return @"document.getElementById('activity-name').style.display=\"none\";document.getElementById('post-date').style.display=\"none\";document.getElementById('post-user').style.display=\"none\";var e = document.getElementById('post-user').parentNode; e.parentNode.removeChild(e);";
}
@end
