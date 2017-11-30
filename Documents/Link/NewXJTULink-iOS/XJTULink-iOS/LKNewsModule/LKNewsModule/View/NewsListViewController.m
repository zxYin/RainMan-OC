//
//  NewsListViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/17.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NewsListViewController.h"
#import "ViewsConfig.h"
#import "NewsViewCell.h"
#import "LKNewsBrowser.h"
@interface NewsListViewController ()<UITableViewDelegate, UITableViewDataSource,LKEmptyManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NewsListViewModel * viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻列表";
    [self.view addSubview:self.tableView];
    
    
    @weakify(self);
    [[[RACObserve(self.viewModel, newsItemViewModels) skip:1]
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
    
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.edgesForExtendedLayout = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.networkingRAC.cancelCommand execute:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsViewCellIdentifier
                                                            forIndexPath:indexPath];
    NewsItemViewModel *viewModel = self.viewModel.newsItemViewModels[indexPath.row];
    viewModel.boxHidden = YES;
    cell.viewModel =viewModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.newsItemViewModels count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsItemViewModel *viewModel = self.viewModel.newsItemViewModels[indexPath.row];
    LKNewsBrowser *vc = [[LKNewsBrowser alloc]initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getter && setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        
        UINib *newsNib = [UINib nibWithNibName:@"NewsViewCell" bundle:nil];
        [_tableView registerNib:newsNib forCellReuseIdentifier:NewsViewCellIdentifier];

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"呀~ 都被你看光啦 (*/ω＼*)" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        _tableView.mj_footer = footer;
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NewsListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[NewsListViewModel alloc] init];
    }
    return _viewModel;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
        _emptyManager.delegate = self;
    }
    return _emptyManager;
}
@end
