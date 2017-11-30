//
//  ProfileViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewsConfig.h"
#import "LKNetworking.h"
#import "User.h"
#import "AppContext.h"
#import "AppMediator+LKLoginModule.h"
#import "AvatarViewController.h"
#import "AppContext.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate,YLAPIManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *netIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;


@property (nonatomic, strong) YLBaseAPIManager *logoutAPIManager;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    
    self.avatarImageView.layer.cornerRadius = 3.0;
    self.avatarImageView.layer.borderWidth = 1.0;
    self.avatarImageView.layer.borderColor = [UIColor brownColor].CGColor;
    self.avatarImageView.clipsToBounds = YES;
    
    User *user = [User sharedInstance];
    @weakify(self);
    [RACObserve(user, avatarURL) subscribeNext:^(id x) {
        @strongify(self);
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:x]];
    }];
    
    RAC(self.nameLabel, text) = RACObserve(user, name);
    RAC(self.netIdLabel, text) = RACObserve(user, netId);
    RAC(self.nicknameLabel, text) = RACObserve(user, nickname);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                AvatarViewController *vc = [[AvatarViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
//                NSArray *photos = [IDMPhoto photosWithURLs:@[[NSURL URLWithString:[User sharedInstance].avatarURL]]];
//                
//                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:self.avatarImageView]; 
//                browser.displayActionButton = YES;
//                browser.actionButtonTitles = @"上传新头像";
//                browser.usePopAnimation = YES;
//                browser.dismissOnTouch = YES;
//                browser.scaleImage = self.avatarImageView.image;
//                [self presentViewController:browser animated:YES completion:nil];
//                
                
//                [self.navigationController pushViewController:browser animated:YES];
                
//                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] init];
                
                 // 跳转选头像
//                [self showAvatarPicker];
                break;
            }
            case 3: {
                
                break;
            }
            default:
                break;
        }
        
        
    } else if (indexPath.section == 1) {
        TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"退出登录" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
            [AppContext showProgressLoading];
            [self.logoutAPIManager loadData];
        }];
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        [actionSheet show];
    }
    
    
}


#pragma mark - YLAPIManagerDelegate
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    [AppContext dismissProgressLoading];
    [AppContext showProgressFinishHUDWithMessage:@"注销成功"];
    NSString *userId = [User sharedInstance].userId;
//    [User RESET];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LKNotificationUserDidLogout object:userId];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LKMain" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [storyboard instantiateInitialViewController];
    
    [[AppMediator sharedInstance] LKLogin_presentLoginViewControllerWithSuccess:^{
        
    } animation:YES];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    [AppContext showProgressFailHUDWithMessage:@"注销失败"];
}

#pragma mark - getter
- (YLBaseAPIManager *)logoutAPIManager {
    if(_logoutAPIManager == nil) {
        _logoutAPIManager = [[AppMediator sharedInstance] LKLogin_logoutAPIManager];
        _logoutAPIManager.delegate = self;
    }
    return _logoutAPIManager;
}
@end
