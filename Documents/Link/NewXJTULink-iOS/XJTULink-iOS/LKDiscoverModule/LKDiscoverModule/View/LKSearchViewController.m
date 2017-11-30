//
//  SearchResultViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSearchViewController.h"
#import "ViewsConfig.h"
#import "ClubItemCell.h"
#import "SpecialColumnView.h"
#import "SearchViewModel.h"
#import "ClubViewController.h"
#import "LKSearchBar.h"
#import "LKEmptyManager.h"
#import "Foundation+LKTools.h"
#import "LKWebBrowser.h"

@interface LKSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, LKSearchBarDelegate, LKEmptyManagerDelegate, SpecialColumnDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKSearchBar *searchBar;
@property (nonatomic, strong) SpecialColumnView *articleView;
@property (nonatomic, strong) SearchViewModel *viewModel;
@property (nonatomic, copy, readonly) NSString *placeholder;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end
@implementation LKSearchViewController
- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        _hideBackButton = YES;
        _placeholder = placeholder;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationController.
//    if([self respondsToSelector:@selector(setRt_disableInteractivePop:)]) {
//        self.rt_disableInteractivePop = YES;
//    }
    
    [self.navigationItem setHidesBackButton:self.hideBackButton];
    
    [self.navigationController.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStylePreview);
    self.emptyManager.title = self.placeholder;
    self.emptyManager.verticalOffset = - 40;
    self.emptyManager.allowTouch = NO;
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self back];
    }];
    
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self setupRAC];
    [self.searchBar becomeFirstResponder];
}

- (void)setupRAC {
    @weakify(self);
    
    [self.viewModel.networkingRAC.executionSignal subscribeNext:^(id x) {
        if ([self.viewModel.clubViewModels count] == 0
            && [self.viewModel.specialColumnModel.items count] == 0
            ) {
            self.emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
            self.emptyManager.delegate = self;
        }
    }];
    
    [[[RACObserve(self.viewModel, clubViewModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
    
    [[[RACObserve(self.viewModel, specialColumnModel) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         if([self.viewModel.specialColumnModel.items count]>0) {
             self.tableView.tableHeaderView = self.articleView;
             self.articleView.viewModel = self.viewModel.specialColumnModel;
         } else {
             self.tableView.tableHeaderView = nil;
         }
     }];
    
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         
         [RKDropdownAlert title:@"网络错误"];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
    
    
    RAC(self.viewModel, keywords) = RACObserve(self.searchBar, text);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:NO];
    if([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.animateEnable) {
        CGRect oldFrame = self.searchBar.frame;
        CGRect frame = oldFrame;
        frame.origin.y = -oldFrame.size.height;
        self.searchBar.frame = frame;
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.searchBar.frame = oldFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}
#pragma mark - YLSearchBarDelegate
- (void)searchBarSearchButtonClicked:(LKSearchBar *)searchBar {
    if ([NSString isBlank:searchBar.text]) {
        [self back];
        return;
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchBarCancelButtonClicked:(LKSearchBar *)searchBar {
    [self back];
}

-(void)emptyManager:(LKEmptyManager *)manager didTapView:(UIView *)view {
    self.emptyManager.displayEnable = NO;
    [self.tableView reloadEmptyDataSet];
    [self.tableView.mj_header beginRefreshing];
}


- (void)specialColumn:(SpecialColumnView *)view didTapIndex:(NSInteger)index {
    SingleURLModel *model = self.viewModel.specialColumnModel.items[index];
    LKWebBrowser *vc = [[LKWebBrowser alloc] initWithURL:model.url title:model.title];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ClubItemCellIdentifier
                                                         forIndexPath:indexPath];
    ClubViewModel *viewModel = self.viewModel.clubViewModels[indexPath.row];
    cell.viewModel = viewModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.clubViewModels count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClubViewModel *viewModel = self.viewModel.clubViewModels[indexPath.row];
    UIViewController *vc;
    if (viewModel.showType == kPageShowTypeWeb) {
        vc = [LKWebBrowser webBrowserWithURL:viewModel.webURL title:viewModel.name];
    } else {
        vc = [[ClubViewController alloc] initWithViewModel:viewModel];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter

- (SearchViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[SearchViewModel alloc] init];
    }
    return _viewModel;
}

- (SpecialColumnView *)articleView {
    if (_articleView == nil) {
        _articleView =
        [[SpecialColumnView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, SpecialColumnViewHeight)];
        _articleView.delegate = self;
    }
    return _articleView;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = ClubItemCellHeight;
        _tableView.backgroundColor = [UIColor whiteColor];

        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.requestCommand];
        self.tableView.tableFooterView = [UIView new];
        UINib *clubNib = [UINib nibWithNibName:@"ClubItemCell" bundle:nil];
        [self.tableView registerNib:clubNib forCellReuseIdentifier:ClubItemCellIdentifier];
    }
    return _tableView;
}

- (LKSearchBar *)searchBar {
    if (_searchBar == nil) {
        CGRect frame = self.navigationController.navigationBar.frame;
        if(!self.hideBackButton) {
            frame.origin.x = 60;
            frame.size.width -= 60;
        }
        frame.origin.y = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + 2;
        _searchBar = [[LKSearchBar alloc] initWithFrame:frame];
        _searchBar.placeholder = self.placeholder;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
