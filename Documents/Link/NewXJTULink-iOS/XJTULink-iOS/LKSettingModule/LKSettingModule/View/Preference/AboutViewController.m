//
//  AboutViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AboutViewController.h"
#import "ViewsConfig.h"
#import "AppContext.h"
#import "TBActionSheet.h"
#import "Macros.h"
#import "User.h"
#import <MessageUI/MessageUI.h>

@interface AboutViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)mailButtonDidClick:(UIButton *)sender {
    TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
    [actionSheet addButtonWithTitle:@"复制邮箱" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        [UIPasteboard generalPasteboard].string = kLinkMail;
        [AppContext showProgressFinishHUDWithMessage:@"复制成功"];
    }];
    
    if ([MFMailComposeViewController canSendMail]) {
        [actionSheet addButtonWithTitle:@"反馈" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            [self showMailSender];
        }];
    }
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

- (void)showMailSender {
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
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)weiboButtonDidClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kLinkWeiboURL]];
}

@end
