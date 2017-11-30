//
//  PreferenceViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "PreferenceViewController.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "LKDebugViewController.h"

typedef NS_ENUM(NSInteger, LKPreferenceSection) {
    kLKPreferenceSectionNotification = 0,
    kLKPreferenceSectionFingerprint,
    kLKPreferenceSectionDebug,
};

@interface PreferenceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *notificationStatusLabel;
@property (nonatomic, assign) NSInteger countOfItems;
@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isDebugMode = [LKUserDefaults boolForKey: LKUserDefaultsDebugMode];
    self.countOfItems = 2 + (isDebugMode?1:0);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (UIUserNotificationTypeNone ==
        [[UIApplication sharedApplication] currentUserNotificationSettings].types) {
        self.notificationStatusLabel.text = @"已关闭";
    } else {
        self.notificationStatusLabel.text = @"已开启";
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.countOfItems;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case kLKPreferenceSectionNotification: {
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                [[UIApplication sharedApplication] openURL:settingURL];
            }
            break;
        }
        case kLKPreferenceSectionFingerprint: {
            
            break;
        }
        case kLKPreferenceSectionDebug: {
            LKDebugViewController *vc = [[LKDebugViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}





@end
