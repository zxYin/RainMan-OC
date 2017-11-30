//
//  LKLoginViewController.m
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLoginViewController.h"
#import "ViewsConfig.h"
#import "LKSecurity.h"
#import "User.h"
#import "NSString+Base64.h"
#import "User+Auth.h"
#import "User+Persistence.h"
#import "AppContext.h"
#import "NSDictionary+LKValueGetter.h"
#import "AppMediator+LKFlowModule.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "NSUserDefaults+LKTools.h"
#import "LKLoginDenyAlertView.h"
#import <MessageUI/MessageUI.h>

static NSString * const LKLoginURL = @"https://link.xjtu.edu.cn/api/2.0/auth/login/";

@interface LKLoginViewController () {
    NSString *_netId;
    NSString *_password;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) void(^callback)();
@end

@implementation LKLoginViewController
- (instancetype)init {
    self = [super initWithURL:[NSURL URLWithString:LKLoginURL] title:@"西交Link"];
    if (self) {
        self.closeButtonEnable = NO;
        self.handoffEnable = NO;
        [self clearCacheAndCookies];
    }
    return self;
}

- (instancetype)initWithCallback:(void (^)())block {
    self = [super initWithURL:[NSURL URLWithString:LKLoginURL] title:@"西交Link"];
    if (self) {
        self.callback = block;
        self.handoffEnable = NO;
        self.closeButtonEnable = NO;
        [self clearCacheAndCookies];
    }
    return self;
}

- (NSString *)JavaScriptInjection {
    return
    @"var msgDiv = document.getElementById('msg');"
     "var height = '170px';"
     "if(msgDiv) {"
         "msgDiv.style.marginBottom = '10px';"
         "height = '200px';"
     "}"
     "document.getElementById('login_box_mobile').style.height = height;"
     "document.getElementById('footer_text').innerHTML='开发维护：西安交通大学·零客工作室<br>联系邮箱：support@xjtu.link';";
}


- (NSString *)JavaScriptSubmitAction {
    return
    @"document.getElementsByName('submit')[0].onclick = function(){ window.webkit.messageHandlers.login.postMessage({'username':document.getElementById('username').value, 'password':document.getElementById('password').value}) }";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 超过三十秒没有打开，说明可能出了问题，弹个通知！
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                  target:self
                                                selector:@selector(timeout)
                                                userInfo:nil
                                                 repeats:NO];
    
    
    WKUserScript *changeFooter = [[WKUserScript alloc] initWithSource:[self JavaScriptInjection] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:changeFooter];
    
    WKUserScript *submitAction = [[WKUserScript alloc] initWithSource:[self JavaScriptSubmitAction] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.webView.configuration.userContentController addUserScript:submitAction];
    
    
    self.webView.allowsBackForwardNavigationGestures = NO;
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"login"];
    
    
    self.moreEnable = NO;
    [self clearCacheAndCookies];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
     bk_initWithImage:[UIImage imageNamed:@"course_refresh_nav_normal"]
     style:UIBarButtonItemStylePlain
     handler:^(id sender) {
         @strongify(self);
         [self clearCacheAndCookies];
         [self reloadWebView];
    }];
    
    if(![LKUserDefaults boolForKey:LKUserDefaultsForceLogin defaultValue:YES]) {
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc]
         bk_initWithImage:[UIImage imageNamed:@"close_navBar_icon"]
         style:UIBarButtonItemStylePlain
         handler:^(id sender) {
             @strongify(self);
             [self dismissWithFinish:NO];
         }];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"login"]) {
        _netId = [message.body stringForKey:@"username"];
        _password = [message.body stringForKey:@"password"];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSURL *url = webView.URL;
    NSLog(@"[%s],%@",__func__, url.absoluteString);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSLog(@"[%s],%@",__func__, url.absoluteString);
    
    if ([url.scheme isEqualToString:@"xjtulink"]){
        
        [self userDidLogin:[url.absoluteString substringFromIndex:11]];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)dismissWithFinish:(BOOL)finish {
    if ([self.delegate respondsToSelector:@selector(loginViewController:dismissWithBlock:finish:)]) {
        [self.delegate loginViewController:self dismissWithBlock:self.callback finish:finish];
    }
}

- (void)userDidLogin:(NSString *)response {
    NSData *jsonData = [response base64DecodedData];
    
    NSError *err;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
    if (err != nil) {
        [self reloadWebView];
        [self showDenyView:@"数据格式错误"];
        return;
    }
    
    NSDictionary *userInfo = dict[@"user_info"];
    
    [User RESET];
    User *user = [User sharedInstance];
    user.netId = _netId;
    user.userId = [dict stringForKey:@"user_id"];
    user.name =  [userInfo stringForKey:@"name"];
    user.nickname = [userInfo stringForKey:@"nickname"];
    user.avatarURL = [userInfo stringForKey:@"portrait"];
    
    NSString *encryptedUserToken = [dict stringForKey:@"user_token"];
    NSLog(@"encryptedUserToken: %@",encryptedUserToken);
    NSString *userToken = [[LKSecurity sharedInstance] rsaDecryptString:encryptedUserToken];
    NSLog(@"userToken: %@",userToken);
    NSLog(@"netid = %@, password = %@",_netId, _password);
    [User saveNetId:_netId password:_password token:userToken forUser:user.userId];

    [self fetchCookieValueForKey:@"CASTGC" completionHandler:^(NSString *cookie) {
        [user tryUpdateUserToken:cookie];
        [[[User sharedInstance].networkingRAC requestCommand] execute:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LKNotificationUserDidLogin
                                                            object:user.userId];
        [self dismissWithFinish:YES];
    }];

}

- (void)timeout {
    [self showDenyView:@"还没打开登录页面？这肯定不是程序猿偷偷不让你登的，但是一定程序猿的锅，投诉！投诉！"];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}


- (void)showDenyView:(NSString *)message {
    LKLoginDenyAlertView *contentView =
    [LKLoginDenyAlertView viewWithBlock:^{
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            mailPicker.navigationBar.translucent = NO;
            mailPicker.navigationBar.tintColor = [UIColor whiteColor];
            [mailPicker setSubject:[NSString stringWithFormat:@"西交Link-%@-用户反馈",[User sharedInstance].nickname]];
            [mailPicker setToRecipients:[NSArray arrayWithObjects:@"support@xjtu.link", nil]];
            [self presentViewController:mailPicker animated:YES completion:nil];
        } else {
            [AppContext showAlertWithTitle:@"无法发送邮件" message:@"你的设备不支持发邮件，需要你配置你的设备或手动发送邮件至support@xjtu.link。"];
        }
    }];
    contentView.contentLabel.text = message;
    LKNoticeAlert *alert = [[LKNoticeAlert alloc] initWithContentView:contentView];
    [alert show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
