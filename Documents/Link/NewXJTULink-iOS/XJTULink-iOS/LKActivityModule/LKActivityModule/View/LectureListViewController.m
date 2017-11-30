//
//  LectureListViewController.m
//  LKActivityModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureListViewController.h"
#import "ViewsConfig.h"
#import "LectureListViewModel.h"
#import "LectureItemCell.h"
#import "LKWebBrowser.h"
//#import "LKLectureBrowser.h"
@interface LectureListViewController ()<UITableViewDelegate, UITableViewDataSource,LKEmptyManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) LectureListViewModel * viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation LectureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻列表";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    @weakify(self);
    [[[RACObserve(self.viewModel, lectureItemViewModels) skip:1]
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
    LectureItemCell *cell = [tableView dequeueReusableCellWithIdentifier:LectureItemCellIdentifier
                                                         forIndexPath:indexPath];
    LectureItemViewModel *viewModel = self.viewModel.lectureItemViewModels[indexPath.row];
    cell.viewModel = viewModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.lectureItemViewModels count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LectureItemViewModel *viewModel = self.viewModel.lectureItemViewModels[indexPath.row];
    LKWebBrowser *vc = [LKWebBrowser webBrowserWithURL:viewModel.url title:@"讲座信息"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LectureViewCellHeight;
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UINib *LectureNib = [UINib nibWithNibName:@"LectureItemCell" bundle:nil];
        [self.tableView registerNib:LectureNib forCellReuseIdentifier:LectureItemCellIdentifier];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"呀~ 都被你看光啦 (*/ω＼*)" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        _tableView.mj_footer = footer;
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (LectureListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LectureListViewModel alloc] init];
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
