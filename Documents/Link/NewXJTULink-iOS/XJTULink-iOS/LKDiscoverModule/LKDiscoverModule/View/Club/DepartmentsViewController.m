//
//  DepartmentsViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DepartmentsViewController.h"
#import "ViewsConfig.h"
#import "DepartmentPageView.h"
#import "UIImage+LKExpansion.h"

@interface DepartmentsViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) DepartmentsViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation DepartmentsViewController
- (instancetype)initWithViewModel:(DepartmentsViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"close_navBar_icon"] imageWithTintColor:[UIColor blackColor]] style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setupDepartments];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-10);
    }];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.translucent = YES;
    UIColor *tintColor = self.viewModel.tintColor;
    if(tintColor) {
        [navBar lt_setBackgroundColor:[tintColor colorWithAlphaComponent:0.8]];
        UIColor *contColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:tintColor isFlat:NO];
        
        [navBar setTintColor:contColor];
        [navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:contColor }];
        
    } else {
        [navBar lt_setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] ];
    }
    
    if([self.viewModel.departments count] == 0) {
        [self.emptyManager reloadEmptyDataSet];
    }
}


- (void)setupDepartments {
    NSLog(@"self.viewModel.departments:%@",self.viewModel.departments);
    NSInteger numberOfDepartments = [self.viewModel.departments count];
    
    self.contentScrollView.contentSize = CGSizeMake(MainScreenSize.width * numberOfDepartments, 0);
    self.contentScrollView.pagingEnabled = YES;
    
    __block CGFloat direction = arc4random() % 2 == 0?1:-1;
    __block CGFloat referenceHeight =[self nextHeightFrom:MainScreenSize.height * 0.618 direction:direction];
    [self.viewModel.departments enumerateObjectsUsingBlock:^(DepartmentModel * _Nonnull departmentModel, NSUInteger idx, BOOL * _Nonnull stop) {
        DepartmentPageView *page = [[DepartmentPageView alloc]initWithModel:departmentModel];
        CGRect frame = page.frame;
        frame.origin.x = MainScreenSize.width * idx;
        page.frame = frame;
        page.leftHeight = referenceHeight;
        page.rightHeight = [self nextHeightFrom:page.leftHeight direction:-direction];
        referenceHeight = page.rightHeight;
        direction = - direction;
        [self.contentScrollView addSubview:page];
    }];
    
    
    self.pageControl.numberOfPages = numberOfDepartments;
    if (numberOfDepartments == 1) {
        self.pageControl.hidden = YES;
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.viewModel.tintColor == nil) {
        return UIStatusBarStyleLightContent;
    }
    UIColor *color = [UIColor colorWithContrastingBlackOrWhiteColorOn:self.viewModel.tintColor isFlat:NO];
    if ([[color hexValue] isEqualToString:@"#FFFFFF"]) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / MainScreenSize.width);
}


- (CGFloat)nextHeightFrom:(CGFloat)height direction:(CGFloat)direction {
    
    CGFloat maxOffset = MainScreenSize.width < 375 ? 100 :200;
    CGFloat scale = MainScreenSize.width < 374 ? 0.75 :0.618;
    NSInteger offset = (NSInteger)(MainScreenSize.height * 0.382) / 2;
    CGFloat result = height;
    do {
        result = MainScreenSize.height * scale + direction * (arc4random() % offset);
    } while (fabs(result - height) > maxOffset || fabs(result - height) < 50);
    return result;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.contentScrollView,LKEmptyManagerStyleNoData);
        _emptyManager.allowTouch = NO;
    }
    return _emptyManager;
}

@end
