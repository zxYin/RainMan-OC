//
//  ClubViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubViewController.h"
#import "ViewsConfig.h"

#import "LKWebBrowser.h"
#import "DepartmentsViewController.h"
#import "ActivityListViewController.h"
#import "LKShareManager.h"
#import "UIImage+LKExpansion.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "LKSharePanel.h"

@interface ClubViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolleView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIImageView *localeIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *honorLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;


@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) ClubViewModel *viewModel;

@end

@implementation ClubViewController
#pragma mark - init

- (instancetype)initWithViewModel:(ClubViewModel *)viewModel {    
    self = [super initWithNibName:@"ClubViewController" bundle:nil];
    if (self) {
        self.viewModel = viewModel;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRAC];

    [self.contentScrolleView addSubview:self.imageView];
    [self.contentScrolleView sendSubviewToBack:self.imageView];
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    effectView.alpha = 0.5f;
//    [self.imageView addSubview:effectView];
//
//    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"close_navBar_icon"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
    [self.viewModel.networkingRAC.requestCommand execute:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleContrast;
}

- (void)setupRAC {
    @weakify(self);
    
    [RACObserve(self.imageView, image) subscribeNext:^(id x) {
        UIColor *color = AverageColorFromImage(self.imageView.image);
        
        UIView *mask = [self.imageView viewWithTag:10001];
        if (mask) {
            mask.backgroundColor = [self.colorForClub colorWithAlphaComponent:0.35];
        } else {
            mask = [[UIView alloc] initWithFrame:CGRectZero];
            mask.tag = 10001;
            [self.imageView addSubview:mask];
            [mask mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        
        UIColor *textColor = ContrastColor(color, NO);
        UIColor *flatTextColor = [textColor lightenByPercentage:0.4];
        self.nameLabel.textColor = textColor;
        self.summaryLabel.textColor = flatTextColor;
        self.typeLabel.textColor = textColor;
        self.localeLabel.textColor = textColor;
        self.localeIconImageView.image = [[UIImage imageNamed:@"club_locale_icon_normal"] imageWithTintColor:textColor];
        
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    RAC(self.nameLabel, text) = RACObserve(self.viewModel, name);
    RAC(self.honorLabel, text) = RACObserve(self.viewModel, honor);
    RAC(self.summaryLabel, text) = RACObserve(self.viewModel, summary);
    RAC(self.localeLabel, text) = RACObserve(self.viewModel, locale);
    RAC(self.typeLabel, text) = RACObserve(self.viewModel, type);
    RAC(self.introductionLabel, text) = RACObserve(self.viewModel, introduction);
    [RACObserve(self.viewModel, imageURL) subscribeNext:^(id x) {
        @strongify(self);
        [self.imageView sd_setImageWithURL:self.viewModel.imageURL
                          placeholderImage:[UIImage imageNamed:@"default_club_image"]];
    }];
    
    [RACObserve(self.viewModel, isAllowApply) subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]
            && [NSString notBlank:self.viewModel.applyURL.absoluteString]) {
            
            self.applyButton.enabled = YES;
            
            UIColor *color = [self colorForClub];
            self.applyButton.backgroundColor = color;
            [self.applyButton setTitle:@"申请加入" forState:UIControlStateNormal];
            [self.applyButton setTitleColor:[UIColor colorWithContrastingBlackOrWhiteColorOn:color isFlat:NO] forState:UIControlStateNormal];

        } else {
            self.applyButton.enabled = NO;
            self.applyButton.backgroundColor = [UIColor lightGrayColor];
            [self.applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.applyButton setTitle:@"暂未开放申请" forState:UIControlStateNormal];
        }
    }];
    
    
    [RACObserve(self.viewModel, shareURLString) subscribeNext:^(id x) {
        if (x != nil) {
            @strongify(self);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_share_item_normal"] style:UIBarButtonItemStyleDone handler:^(id sender) {
                @strongify(self);
                LKShareModel *model = self.viewModel.shareModel;
                model.image = self.imageView.image;
                LKSharePanel *panel = [[LKSharePanel alloc] initWithShareModel:model];
                panel.title = [NSString stringWithFormat:@"邀请好友加入%@吧！",self.viewModel.name];
                [panel show];
            }];
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat barHeight = [self realNavigationBarHeight];
    if (offset < - barHeight) {
        CGRect frame = self.imageView.frame;
        frame.origin.y = offset;
        
        CGFloat originHeight = 9 * MainScreenSize.width / 16;
        frame.size.height = originHeight + fabs(offset + barHeight);
        self.imageView.frame = frame;
    }
}

- (IBAction)departmentButtonDidClick:(UIView *)sender {
    self.viewModel.departmentsViewModel.tintColor =  [self colorForClub];
    DepartmentsViewController *departmentsVC = [[DepartmentsViewController alloc] initWithViewModel:self.viewModel.departmentsViewModel];
    departmentsVC.title = self.viewModel.name;
    [self.navigationController pushViewController:departmentsVC animated:YES];
}

- (IBAction)activityButtonDidClick:(UIView *)sender {
    ActivityListViewModel *viewModel = [[ActivityListViewModel alloc] initWithClubId:self.viewModel.clubId];
    viewModel.tintColor = [self colorForClub];
    ActivityListViewController *activityListVC = [[ActivityListViewController alloc] initWithViewModel:viewModel];
    
    [self.navigationController pushViewController:activityListVC animated:YES];
}

- (IBAction)applyButtonDidClick:(UIButton *)sender {
    if (self.viewModel.applyURL != nil) {
        LKWebBrowser *webBrowser = [LKWebBrowser webBrowserWithURL:self.viewModel.applyURL title:self.viewModel.name];
//        webBrowser.executeJS = self.viewModel.applyPageJS;
        
        @weakify(self);
        webBrowser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"close_navBar_icon"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        LKShareModel *model = self.viewModel.shareModel;
        model.image = self.imageView.image;
        webBrowser.shareModel = model;
        UIColor *color = [self colorForClub];
        webBrowser.navTintColor = color;
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}


- (UIColor *)colorForClub {
    UIColor *defaultColor = AverageColorFromImage([UIImage imageNamed:@"default_club_image"]);
    UIColor *currentColor = AverageColorFromImage(self.imageView.image);
    if (CGColorEqualToColor(currentColor.CGColor,defaultColor.CGColor)) {
        return LKColorLightBlue;
    }
    return currentColor;
}



- (UIImageView *)imageView {
    if (_imageView == nil) {
        CGFloat height = 9 * MainScreenSize.width / 16;
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_club_image"]];
        _imageView.frame = CGRectMake(0, -[self realNavigationBarHeight], MainScreenSize.width, height);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end
