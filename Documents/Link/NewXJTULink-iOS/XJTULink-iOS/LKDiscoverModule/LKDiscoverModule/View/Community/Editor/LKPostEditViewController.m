//
//  ConfessionEditViewController.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostEditViewController.h"
#import "ViewsConfig.h"
#import "LKTextView.h"
#import "Macros.h"
#import "ReferEditViewController.h"
#import "LKPostAPIManager.h"
#import "Foundation+LKTools.h"
#import "ColorMacros.h"
#import "CommunityContext.h"

static NSInteger const ConfessionTextMaxLength = 300;
@interface LKPostEditViewController ()<YLAPIManagerDelegate, YLAPIManagerDataSource>
@property (nonatomic, strong) LKTextView *textView;
@property (nonatomic, strong) UIButton *referButton;
@property (nonatomic, strong) UILabel *wordsCountLabel;
@property (nonatomic, copy) NSString *referName;
@property (nonatomic, copy) NSString *referAcademy;
@property (nonatomic, copy) NSString *referClass;

@property (nonatomic, copy) LKPostAPIManager *submitAPIManager;

@end

@implementation LKPostEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommunityContext *context = [CommunityContext currentContext];
    [self.navigationController.navigationBar lt_setBackgroundColor:context.tintColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = context.currentOption.editorContext.title;
    
    self.textView.placeholder = context.currentOption.editorContext.placeholder;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 50, 5));
    }];
    
    [self.view addSubview:self.referButton];
    @weakify(self);
    [self.referButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.textView.mas_bottom).offset(14);
        make.trailing.equalTo(self.textView).offset(-7);
    }];
    [self updateReferButtonSize];
    
    [self.view addSubview:self.wordsCountLabel];
    [self.wordsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.referButton.mas_centerY);
        make.right.equalTo(self.referButton.mas_left).offset(-5);
    }];
    RAC(self.wordsCountLabel, text) = [self.textView.rac_textSignal map:^id(id value) {
        @strongify(self);
        NSInteger length = [value length];
        self.wordsCountLabel.hidden = (length==0);
        if (length > ConfessionTextMaxLength) {
            self.wordsCountLabel.textColor = LKColorRed;
        } else {
            self.wordsCountLabel.textColor = LKColorGray;
        }
        return [NSString stringWithFormat:@"%td",[value length]];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithImage:[UIImage imageNamed:@"nav_send_normal"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [AppContext showProgressLoading];
        [self.submitAPIManager loadData];
    }];
    
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) =
    [self.textView.rac_textSignal map:^id(id value) {
        NSString *text = [value stringByTrimmingDefault];
        return @([NSString notBlank:text] && text.length <= ConfessionTextMaxLength);
    }];

    [[RACObserve(self, referName)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSString *name) {
        @strongify(self);
         [UIView performWithoutAnimation:^{
             if ([NSString notBlank:name]) {
                 [self.referButton setTitle:name forState:UIControlStateNormal];
             } else {
                 [self.referButton setTitle:@"写给TA" forState:UIControlStateNormal];
             }
         }];
        [self updateReferButtonSize];
    }];
    
    self.referButton.hidden = !context.currentOption.allowRefer;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    LKPostModel *model = [self.submitAPIManager fetchDataFromModel:[LKPostModel class]];
    if (model != nil
        && self.didSubmitBlock) {
        self.didSubmitBlock(model);
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, endFrame.size.height + 50, 5));
    }];
    [self.view.superview layoutIfNeeded];
}

#pragma mark - Button

- (void)updateReferButtonSize {
    NSString *text = [self.referButton titleForState:UIControlStateNormal];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:self.referButton.titleLabel.font.fontName size:self.referButton.titleLabel.font.pointSize]}];
    textSize.height = 26;
    textSize.width  += 40;
    [self.referButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(textSize);
    }];
}

- (void)referEditButtonDidClick:(id)sender {
    ReferEditViewController *vc = [[ReferEditViewController alloc] init];
    if ([NSString notBlank:self.referName]) {
        vc.referName = self.referName;
        vc.referClass = self.referClass;
        vc.referAcademy = self.referAcademy;
    }
    
    @weakify(self);
    [vc setFinish:^(BOOL finish, NSString *referName, NSString *referAcademy, NSString *referClass) {
        @strongify(self);
        if (finish) {
            self.referName = referName;
            self.referAcademy = referAcademy;
            self.referClass = referClass;
        }
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)note {
    [self.textView becomeFirstResponder];
}


#pragma makr - YLAPIManagerDataSource

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kPostAPIManagerParamsKeyContent] = self.textView.text;
    params[kPostAPIManagerParamsKeyReferName] = self.referName;
    params[kPostAPIManagerParamsKeyReferAcademy] = self.referAcademy;
    params[kPostAPIManagerParamsKeyReferClass] = self.referClass;
    
    CommunityContext *context = [CommunityContext currentContext];
    params[kPostAPIManagerParamsKeyCommunityId] = context.communityId;
    params[kPostAPIManagerParamsKeyOptionId] = context.currentOption.optionId;
    return params;
}

#pragma mark - YLAPIManagerDelegate
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    [AppContext showProgressFinishHUDWithMessage:@"发布成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    if(error.code == YLAPIManagerResponseStatusServerMessage) {
        [AppContext dismissProgressLoading];
    } else {
        [AppContext showProgressFailHUDWithMessage:error.message];
    }
    
}

#pragma mark - getter

- (UILabel *)wordsCountLabel {
    if (_wordsCountLabel == nil) {
        _wordsCountLabel = [[UILabel alloc] init];
        _wordsCountLabel.font = [UIFont systemFontOfSize:13];
        _wordsCountLabel.textColor = LKColorGray;
    }
    return _wordsCountLabel;
}

- (LKTextView *)textView {
    if(_textView == nil) {
        _textView = [[LKTextView alloc] initWithFrame:self.view.frame];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.scrollEnabled = YES;
    }
    return _textView;
}

- (UIButton *)referButton {
    if (_referButton == nil) {
        _referButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _referButton.titleLabel.font = [UIFont systemFontOfSize:13];
        UIColor *tintColor = [CommunityContext currentContext].tintColor;
        [_referButton setTintColor:tintColor];
        [_referButton addTarget:self action:@selector(referEditButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _referButton.layer.cornerRadius = 13.0;
        _referButton.layer.borderWidth = 1.0;
        _referButton.layer.borderColor = tintColor.CGColor;
        _referButton.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        _referButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_referButton setImage:[UIImage imageNamed:@"nav_message_icon"] forState:UIControlStateNormal];
        [_referButton setTitle:@"写给TA" forState:UIControlStateNormal];
    }
    return _referButton;
}

- (LKPostAPIManager *)submitAPIManager {
    if (_submitAPIManager == nil) {
        _submitAPIManager = [LKPostAPIManager apiManagerByType:LKPostAPIManagerTypeSubmit];
        _submitAPIManager.dataSource = self;
        _submitAPIManager.delegate = self;
    }
    return _submitAPIManager;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
