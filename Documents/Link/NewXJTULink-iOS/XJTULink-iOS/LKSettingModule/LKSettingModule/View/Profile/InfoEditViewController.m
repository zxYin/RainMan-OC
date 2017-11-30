//
//  InfoEditViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "InfoEditViewController.h"
#import "ViewsConfig.h"
#import "User.h"
#import "StuInfoAPIManager.h"
#import "SVProgressHUD.h"
#import "NSDictionary+LKValueGetter.h"
#import "Foundation+LKTools.h"

@interface InfoEditViewController ()<YLAPIManagerDelegate, YLAPIManagerDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) StuInfoAPIManager *stuInfoAPIManager;
@end

@implementation InfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    self.textField.text = [User sharedInstance].nickname;
    
    [self.textField becomeFirstResponder];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [AppContext showProgressLoadingWithMessage:@"正在保存"];
        [self.stuInfoAPIManager loadData];
    }];
    
    
    RAC(item, enabled) = [self.textField.rac_textSignal map:^id(id value) {
        NSInteger length = [value length];
        return @(length>0 && length<12);
    }];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kStuInfoAPIManagerParamsKeyNickname] = self.textField.text;
    return params;
}


- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    NSDictionary *info = [apiManager fetchData];
    NSString *nickname = [info stringForKey:@"stu_nickname"];
    if ([NSString notBlank:nickname]) {
        [User sharedInstance].nickname = nickname;
    }
    [AppContext showProgressFinishHUDWithMessage:@"更新成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    [AppContext showProgressFailHUDWithMessage:@"更新失败"];
}



- (StuInfoAPIManager *)stuInfoAPIManager {
    if (_stuInfoAPIManager == nil) {
        _stuInfoAPIManager = [[StuInfoAPIManager alloc] init];
        _stuInfoAPIManager.delegate = self;
        _stuInfoAPIManager.dataSource = self;
    }
    return _stuInfoAPIManager;
}

@end
