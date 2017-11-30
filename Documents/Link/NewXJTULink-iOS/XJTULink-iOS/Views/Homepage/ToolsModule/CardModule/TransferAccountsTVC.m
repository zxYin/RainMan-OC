////
////  TransferAccountsTVC.m
////  XJTULink-iOS
////
////  Created by Yunpeng on 15/10/24.
////  Copyright © 2015年 Yunpeng. All rights reserved.
////
//
//#import "TransferAccountsTVC.h"
//#import "UIImage+Color.h"
//#import "TransferPasswordView.h"
//#import "User+Transfer.h"
//#import "PCAngularActivityIndicatorView.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import "ViewsConfig.h"
//#import "UINavigationBar+Awesome.h"
//#import "SSKeychain.h"
//#import <LocalAuthentication/LAContext.h>
//#import "AppConst.h"
//#import "UIAlertController+iPad.h"
//typedef NS_ENUM(NSUInteger,TransferType) {
//    kTransferTypePassword = 0,
//    kTransferTypeFingerPrint,
//};
//
//@interface TransferAccountsTVC () {
//    UIView *loadingBackground;
//    TransferPasswordView *passwordView;
//    UIActivityIndicatorView* activityIndicatorView;
//    UIView *background;
//}
//@property (weak, nonatomic) IBOutlet UIButton *transferButton;
//@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
//@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
//@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
//@property (assign,nonatomic) TransferType transferType;
//
//@property (strong,nonatomic) PCAngularActivityIndicatorView *activityIndicator;
//@end
//
//@implementation TransferAccountsTVC
//
//- (void)viewDidLoad {
//    BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsCardEnable];
//    if (!enable) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//    }
//    [super viewDidLoad];
//    
//    activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
//                             initWithFrame:CGRectMake(15,0,30.0,30.0)];
//    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    
//    self.title = @"在线圈存";
////    self.tableView.backgroundColor = LCOLOR_LIGHT_LIGHT_GRAY;
//    self.tableView.allowsSelection = NO;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.transferButton.layer.cornerRadius = 5.0;
//    self.transferButton.clipsToBounds = YES;
//    
//    self.activityIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
//    self.activityIndicator.color = LCOLOR_BLUE;
//    
//    [self.transferButton setBackgroundImage:[UIImage imageWithColor:LCOLOR_LIGHT_GRAY size:self.transferButton.frame.size] forState:UIControlStateHighlighted];
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fetchCheckCode)];
//    [_codeImageView addGestureRecognizer:tap];
//    
//    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ypli_hideKeyboard)];
//    tapBackground.cancelsTouchesInView = NO;
//    [self.tableView addGestureRecognizer:tapBackground];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    [self fetchCheckCode];
//}
//- (void)ypli_hideKeyboard {
//    [_codeTextField resignFirstResponder];
//    [_moneyTextField resignFirstResponder];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar lt_setBackgroundColor:LCOLOR_BLUE];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar lt_setBackgroundColor:LCOLOR_BLUE];
//}
//- (void)fetchCheckCode {
//    [self ypli_resetCheckCode];
//    [self updateCheckCode];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//
//- (void)ypli_resetCheckCode {
////    _codeImageView.image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(63, 25)];
//    _codeImageView.image = nil;
//    [_codeImageView addSubview:activityIndicatorView];
//    [activityIndicatorView startAnimating];
//}
//
//- (void)updateCheckCode {
//    [[OUser sharedInstance] fetchVerificationCode:^(NSString *urlString, NSError *error) {
//        NSLog(@"获取验证码完成:%@，%@",urlString,error);
//        if (error==nil) {
//            NSString *url = [SERVER_IP stringByAppendingString:urlString];
////            [_codeImageView sd_setImageWithURL:[NSURL URLWithString:url]];
//            [_codeImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (error!=nil) {
//                    [RKDropdownAlert title:@"获取验证码失败了，点击验证码刷新"];
//                    _codeImageView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(63, 25)];
//                }
//                [activityIndicatorView removeFromSuperview];
//            }];
//        } else {
//            [RKDropdownAlert title:@"获取验证码失败了，点击验证码刷新"];
//            _codeImageView.image = [UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(63, 25)];
//            [activityIndicatorView removeFromSuperview];
//        }
//        
//    }];
//}
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
//    
//    if (passwordView!=nil) {
//        CGRect frame = passwordView.frame;
//        frame.origin.y = MainScreenSize.height - height - TransferPasswordViewHeight;
//        [UIView animateWithDuration:0.5 animations:^{
//            passwordView.frame = frame;
//        }];
//    }
////    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
////    [self.tableView setContentOffset:CGPointMake(0, height)];
////    [tableView setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)]
////    [self.tableView setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX) animated:YES];
//    
////    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
//}
//- (void)keyboardWillHide:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect keyboardRect = [value CGRectValue];
//    int height = keyboardRect.size.height;
//    
//    if (passwordView!=nil) {
//        CGRect frame = passwordView.frame;
//        frame.size.height += height;
//        passwordView.frame = frame;
//        
//    }
////    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//}
//
//- (IBAction)tranferButtonDidClick:(UIButton *)sender {
//    if ([_moneyTextField.text isEqualToString:@""]) {
//        [RKDropdownAlert title:@"金额不可为空" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
//        return;
//    }
//    if (![_moneyTextField.text isPureNumandCharacters]) {
//        [RKDropdownAlert title:@"非法金额" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
//        return;
//    }
//    
//    if ([_codeTextField.text isEqualToString:@""]) {
//        [RKDropdownAlert title:@"验证码不可为空" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
//        return;
//    }
//    
//    background = [[UIView alloc]initWithFrame:self.view.frame];
//    background.backgroundColor = [UIColor blackColor];
//    background.opaque = NO;
//    background.alpha = 0.5;
//    [self.navigationController.view addSubview:background];
//    
//    NSString *password = [SSKeychain passwordForService:KEYCHAIN_FOR_FINGERPRINT account:[OUser sharedInstance].user_id];
//    if ([self canEvaluatePolicy] && password!=nil && ![password isEqualToString:@""]) {
//        [self ypli_hideKeyboard];
//        self.transferType = kTransferTypeFingerPrint;
//        [self transferByFingerPrint];
//    } else {
//        self.transferType = kTransferTypePassword;
//        [self transferByPassword];
//    }
//}
//- (void)transferByFingerPrint {
//    LAContext *context = [[LAContext alloc]init];
//    __block NSString *message;
//    __weak __typeof(self) safeSelf = self;
//    context.localizedFallbackTitle = @"输入密码";
//    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError *authenticationError) {
//        if (success) {
//            message = @"evaluatePolicy: succes";
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *password = [SSKeychain passwordForService:KEYCHAIN_FOR_FINGERPRINT account:[OUser sharedInstance].user_id];
//                [safeSelf ypli_transfer:password];
//            });
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [safeSelf transferByPassword];
//            });
//        }
//        NSLog(@"%@",message);
////        [self printMessage:message inTextView:self.textView];
//    }];
//}
//
//- (void)transferByPassword {
//    NSLog(@"按密码转账");
//    __weak __typeof(self) safeSelf = self;
//    passwordView = [TransferPasswordView transferPasswordViewWithSuccessAction:^(NSString *password) {
//        NSLog(@"转账");
//        [safeSelf ypli_transfer:password];
//    } CloseAction:^{
//        [background removeFromSuperview];
//        safeSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    } forgetAction:^{
//        
//    }];
//    passwordView.frame = CGRectMake(0, MainScreenSize.height, MainScreenSize.width, TransferPasswordViewHeight);
//    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self.navigationController.view addSubview:passwordView];
//}
//
//- (void)ypli_transfer:(NSString *)password {
//    CGSize size = MainScreenSize;
//    loadingBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    loadingBackground.backgroundColor = [UIColor blackColor];
//    loadingBackground.alpha = 0.6;
//    [self.navigationController.view addSubview:loadingBackground];
//    _activityIndicator.center = CGPointMake(size.width/2, size.height/2);
//    [_activityIndicator startAnimating];
//    [self.navigationController.view addSubview:self.activityIndicator];
//    
//    __weak __typeof(self) safeSelf = self;
//    [[OUser sharedInstance]tranferMoney:_moneyTextField.text
//                             checkCode:_codeTextField.text
//                              password:password
//                                finish:^(NSString *message) {
//                                    NSLog(@"%@",message);
//                                    [safeSelf transferDidFinish:message password:password];
//                                }];
//    
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        NSString *message = @"Success";
////        [safeSelf transferDidFinish:message password:password];
////    });
//    
//    
//}
//- (void)transferDidFinish:(NSString *)message password:(NSString *)password{
//    _codeTextField.text = @"";
//    [self updateCheckCode];
//    [_activityIndicator stopAnimating];
//    [loadingBackground removeFromSuperview];
//    [background removeFromSuperview];
//    [passwordView close];
//    BOOL isSuccess = NO;
//    NSString *userid = [OUser sharedInstance].user_id;
//    if ([message isEqualToString:@"Success"]) {
//        isSuccess = YES;
//        message = @"圈存成功，在线圈存系统存在延迟，1-3分钟后即可查看本次转账信息。";
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTransferSuccess object:nil];
//        
//        [MobClick event:MobClickEventTransferAccounts
//             attributes:@{
//                          @"type":[self stringWithTransferType:self.transferType],
//                          @"message":message,
//                          }
//                counter:[_moneyTextField.text intValue]];
//    } else if([message isEqualToString:@"查询密码错误"]) {
//        isSuccess = NO;
//        if (self.transferType == kTransferTypeFingerPrint) {
//            [SSKeychain deletePasswordForService:KEYCHAIN_FOR_FINGERPRINT account:userid];
//            message = @"指纹圈存已过期，这可能是由于您修改过查询密码所导致的，请重新输入密码圈存。";
//        }
//    }
//    
//    if (isSuccess && [self canEvaluatePolicy]) {
//        NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:TransferFingerPrintStatusKey];
//        UIAlertController *alert  = [self alertWithStatus:status password:password];
//        if (alert != nil) {
//            [alert safeDevice:self.view];
//            [self presentViewController:alert animated:YES completion:nil];
//            return;
//        }
//    }
//    if ([message rangeOfString:@"NSURLErrorDomain"].location != NSNotFound) {
//        NSLog(@"网络出现异常");
//        message = @"网络异常，请稍候再试。";
//    }
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"在线圈存" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [RKDropdownAlert title:message];
//        if (isSuccess) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }]];
//    [alert safeDevice:self.view];
//    [self presentViewController:alert animated:YES completion:nil];
//}
//
//- (NSString *)stringWithTransferType:(TransferType) type {
//    switch (type) {
//        case kTransferTypePassword:
//            return @"密码圈存";
//        case kTransferTypeFingerPrint:
//            return @"指纹圈存";
//    }
//}
//
//- (UIAlertController *)alertWithStatus:(TransferFingerPrintStatus)status password:(NSString *)password{
//    NSString *message = nil;
//    switch (status) {
//        case TransferFingerPrintClose:
//            // fallthrough
//        case TransferFingerPrintOn:
//            return nil;
//        case TransferFingerPrintUncheck:
//            message = @"圈存成功，在线圈存系统存在延迟，1-3分钟后即可查看本次转账信息。您是否确认开启“指纹圈存”?";
//            break;
//        case TransferFingerPrintNotUse:
//            // fallthrough
//        default:
//            message = @"圈存成功，检测到您已经开启了Touch ID，您是否开启“指纹圈存”？开启后，您将可以使用Touch ID验证指纹快速完成圈存，您也可以在“我”-“设置”-“偏好设置”中关闭指纹圈存。";
//    }
//    
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否开启“指纹圈存?" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [SSKeychain setPassword:password forService:KEYCHAIN_FOR_FINGERPRINT account:[OUser sharedInstance].user_id];
//        [RKDropdownAlert title:@"指纹圈存开启成功"];
//        [[NSUserDefaults standardUserDefaults] setInteger:TransferFingerPrintOn forKey:TransferFingerPrintStatusKey];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"不开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[NSUserDefaults standardUserDefaults] setInteger:TransferFingerPrintClose forKey:TransferFingerPrintStatusKey];
//    }]];
//    return alert;
//
//}
//
//- (void) textFieldDidChange:(UITextField *) textField {
//    NSLog(@"%@",[textField text]);
//}
//
//
//- (BOOL)canEvaluatePolicy {
//    LAContext *context = [[LAContext alloc] init];
//    NSError *error;
//    BOOL success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
//    return success;
//}
//@end
