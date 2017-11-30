//
//  SettingViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/11/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import <MessageUI/MessageUI.h>
#import "LKCacheManager.h"
#import "TBActionSheet.h"
#import "User.h"
#import "AppContext.h"
#import "LKWebBrowser.h"
#import "NSUserDefaults+LKTools.h"

#define kLicenseURL [kServerURL stringByAppendingString:@"/1.0/extra/license/"]
@interface SettingViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *debugButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(showMailSender)];
    self.title = @"设置";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"西交Link V%@(%@)",version,build];

    [self setupDebugMode];
    
    
}

- (void)setupDebugMode {
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [LKUserDefaults setBool:YES forKey:LKUserDefaultsDebugMode];
        [AppContext showProgressFinishHUDWithMessage:@"Debug模式已开启"];
    }];
    tap.numberOfTapsRequired = 5;
    [self.debugButton addGestureRecognizer:tap];
}

- (void)showMailSender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        mailPicker.navigationBar.translucent = NO;
        mailPicker.navigationBar.tintColor = [UIColor whiteColor];
        
        [mailPicker setSubject:[NSString stringWithFormat:@"西交Link-%@-用户反馈",[User sharedInstance].nickname]];
        [mailPicker setToRecipients:@[kLinkMail]];
        [self presentViewController:mailPicker animated:YES completion:nil];
    } else {
        NSString *message = [NSString stringWithFormat:@"你的设备不支持发邮件，需要你配置你的设备或手动发送邮件至%@。",kLinkMail];
        [AppContext showAlertWithTitle:@"无法发送邮件" message:message];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)policiesButtonDidClick:(UIButton *)sender {
    LKWebBrowser *vc = [LKWebBrowser webBrowserWithURL:[NSURL URLWithString:kLicenseURL] title:@"用户协议"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end


typedef NS_ENUM(NSInteger,MineSettingOption) {
    kSettingOptionRate = 0,
    kSettingOptionPrefer,
    kSettingOptionClear,
    kSettingOptionHelp,
    kSettingOptionAboutUs,
};

@interface SettingTableViewController : UITableViewController
@end

@implementation SettingTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case kSettingOptionRate: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStorePath]];
            break;
        }
        case kSettingOptionPrefer: {
            // storyboard中处理
            break;
        }
        case kSettingOptionClear: {
            [self showCacheAlert];
            
            break;
        }
        case kSettingOptionHelp: {
            LKWebBrowser *vc =
            [[LKWebBrowser alloc] initWithURL:[NSURL URLWithString:@"https://link.xjtu.edu.cn/web/help/"] title:@"帮助中心"];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case kSettingOptionAboutUs: {
            // storyboard中处理
            break;
        }
            
        default:
            break;
    }
}


- (void)showCacheAlert {
    [LKCacheManager calculateCacheSizeWithCompletion:^(CGFloat size) {
        TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
        actionSheet.title = [NSString stringWithFormat:@"缓存大小为%.2f M.确定要清理缓存吗？", size / 1024.0 / 1024.0];
        [actionSheet addButtonWithTitle:@"确定" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
            [LKCacheManager clearCacheWithCompletion:^() {
                [AppContext showProgressFinishHUDWithMessage:@"清理完成"];
            }];
            
        }];
        
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        
        [actionSheet show];
        
        
    }];
}
@end

