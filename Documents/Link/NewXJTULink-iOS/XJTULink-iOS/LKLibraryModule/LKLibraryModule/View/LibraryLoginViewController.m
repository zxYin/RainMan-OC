//
//  LibraryLoginViewController.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryLoginViewController.h"
#import "ViewsConfig.h"
#import "AppContext.h"
#import "User+Persistence.h"
#import "LibraryAPIManager.h"
#import "LKSecurity.h"
#import "LKWebBrowser.h"

@interface LibraryLoginViewController ()<YLAPIManagerDelegate, YLAPIManagerDataSource>
@property (nonatomic, strong) LibraryAPIManager *libraryAPIManager;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, copy) void(^callback)();
@end

@implementation LibraryLoginViewController
- (instancetype)initWithCallback:(void (^)())block {
    self = [super init];
    if (self) {
        self.callback = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"借阅查询";

    @weakify(self);
    [self.view bk_whenTapped:^{
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.clipsToBounds = YES;
    
    [self.loginButton addSubview:self.activityIndicatorView];
    

    RACSignal *usernameValid =
    [self.usernameTextField.rac_textSignal map:^id(id value) {
        return @([value length]>0);
    }];
    
    RACSignal *passwordValid =
    [self.passwordTextField.rac_textSignal map:^id(id value) {
        return @([value length]>0);
    }];
    
    RACSignal *paramsValid = [RACSignal combineLatest:@[usernameValid, passwordValid]
                                               reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                                                   return @([usernameValid boolValue]&&[passwordValid boolValue]);
                                               }];
    
    RAC(self.loginButton, enabled) =
    [RACSignal combineLatest:@[paramsValid,
                               RACObserve(self.usernameTextField, enabled)]
      reduce:^id( NSNumber *paramsValid, NSNumber *textFieldEnable){
        return @([paramsValid boolValue]&&[textFieldEnable boolValue]);
    }];
    
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc]
     bk_initWithImage:[UIImage imageNamed:@"close_navBar_icon"]
     style:UIBarButtonItemStylePlain
     handler:^(id sender) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_help_icon_normal"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        LKWebBrowser *vc =
        [[LKWebBrowser alloc] initWithURL:[NSURL URLWithString:@"https://link.xjtu.edu.cn/web/help/class/2/"] title:@"帮助中心"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    [AppContext showMessage:@"图书馆登录成功"];
    
    [User saveLibUsername:self.usernameTextField.text
              libPassword:self.passwordTextField.text
                  forUser:[User sharedInstance].userId];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.callback) {
            self.callback();
        }
    }];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    [AppContext showError:error.message];
    [self.activityIndicatorView stopAnimating];
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.libraryAPIManager == manager) {
        params[kLibraryAPIManagerParamsKeyLibUsername] = self.usernameTextField.text;
        params[kLibraryAPIManagerParamsKeyLibPassword] =
        [[LKSecurity sharedInstance] rsaEncryptString:self.passwordTextField.text];
    }
    return [params copy];
}

#pragma mark - Button Event

- (IBAction)usernameFieldDidEndOnExit:(UITextField *)sender {
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)passwordFieldDidEndOnExit:(UITextField *)sender {
    [self loginButtonDidClick:nil];
}

- (IBAction)loginButtonDidClick:(UIButton *)sender {
    [self.activityIndicatorView startAnimating];
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    [self.libraryAPIManager loadData];
}


#pragma mark - Getter
- (LibraryAPIManager *)libraryAPIManager {
    if (_libraryAPIManager == nil) {
        _libraryAPIManager = [LibraryAPIManager new];
        _libraryAPIManager.dataSource = self;
        _libraryAPIManager.delegate = self;
    }
    return _libraryAPIManager;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                  initWithFrame:CGRectMake(0,0,30.0,30.0)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _activityIndicatorView;
}

@end
