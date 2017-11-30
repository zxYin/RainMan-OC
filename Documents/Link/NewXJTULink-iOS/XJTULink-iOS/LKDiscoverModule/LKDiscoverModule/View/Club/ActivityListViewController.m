//
//  ActivityListViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ViewsConfig.h"
#import "ActivityCell.h"
#import "Macros.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface ActivityListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityListViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation ActivityListViewController
- (instancetype)initWithViewModel:(ActivityListViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团活动";
    
    [self setupRAC];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIColor *tintColor = self.viewModel.tintColor;
    if(tintColor != nil) {
        NSLog(@"设置背景颜色, %@",[tintColor hexValue]);
        navBar.translucent = YES;
        [navBar lt_setBackgroundColor:tintColor];
        UIColor *contColor = ContrastColor(tintColor, NO);
        [navBar setTintColor:contColor];
        [navBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:contColor }];
    } else {
        [navBar setTintColor:[UIColor whiteColor]];
        [navBar lt_setBackgroundColor:LKColorLightBlue];
    }
}

- (void)setupRAC {
    @weakify(self);
    [[[RACObserve(self.viewModel, activityModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.emptyManager reloadEmptyDataSet];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         if (self.viewModel.hasNextPage) {
             [self.tableView.mj_footer endRefreshing];
         } else {
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         [self.emptyManager reloadEmptyDataSet];
         [RKDropdownAlert title:@"网络错误"];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel.networkingRAC.cancelCommand execute:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier
                                                         forIndexPath:indexPath];
    ActivityModel *viewModel = self.viewModel.activityModels[indexPath.section];
    cell.viewModel = viewModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.activityModels count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:ActivityCellIdentifier cacheByIndexPath:indexPath configuration:^(ActivityCell *cell) {
        ActivityModel *viewModel = self.viewModel.activityModels[indexPath.section];
        cell.viewModel = viewModel;
    }];
}

#pragma mark - getter && setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = ActivityCellHeight;
        _tableView.allowsSelection = NO;
        UINib *activityNib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
        [self.tableView registerNib:activityNib forCellReuseIdentifier:ActivityCellIdentifier];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
        self.tableView.tableFooterView = [UIView new];
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        self.tableView.mj_footer = footer;
    }
    return _tableView;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
    }
    return _emptyManager;
}


@end
