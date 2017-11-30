//
//  TranscriptsViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsViewController.h"
#import "TranscriptsViewModel.h"
#import "TranscriptsItemCell.h"
#import "TranscriptsAPIManager.h"
#import "ViewsConfig.h"
#import "LKEmptyManager.h"
#import "Macros.h"
#import "AppContext.h"
@interface TranscriptsViewController ()<UITableViewDelegate, UITableViewDataSource,LKEmptyManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TranscriptsViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@property (nonatomic, strong) TranscriptsAPIManager *transcriptsAPIManager;
@end

@implementation TranscriptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成绩单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib *nib = [UINib nibWithNibName:@"TranscriptsItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TranscriptsItemCell.lk_identifier];
    
    
    @weakify(self);
    [[[RACObserve(self.viewModel, transcriptsItemViewModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [AppContext showProgressFinishHUDWithMessage:@"成绩加载完毕"];
         [self.emptyManager reloadEmptyDataSet];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(YLResponseError *error) {
         @strongify(self);
         [AppContext showProgressFailHUDWithMessage:error.message];
         [self.emptyManager reloadEmptyDataSet];
         [self.tableView.mj_header endRefreshing];
     }];
    
    if (self.viewModel.transcriptsItemViewModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.semesters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.transcriptsItemViewModels[self.viewModel.semesters[section]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TranscriptsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:TranscriptsItemCell.lk_identifier
                                                                forIndexPath:indexPath];
    
    NSString *semester = self.viewModel.semesters[indexPath.section];
    TranscriptsItemViewModel *viewModel = (TranscriptsItemViewModel *)
    self.viewModel.transcriptsItemViewModels[semester][indexPath.row];
    cell.titleLabel.text = viewModel.title;
    cell.scoreLabel.text = viewModel.score;
    
    if (viewModel.isPass) {
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.scoreLabel.textColor = LKColorLightBlue;
    } else {
        cell.titleLabel.textColor = [UIColor redColor];
        cell.scoreLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.viewModel.semesters[section];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.rowHeight = 44;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:[self.viewModel.networkingRAC requestCommand]];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (TranscriptsAPIManager *)transcriptsAPIManager {
    if (_transcriptsAPIManager == nil) {
        _transcriptsAPIManager = [[TranscriptsAPIManager alloc] init];
    }
    return _transcriptsAPIManager;
}

- (TranscriptsViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TranscriptsViewModel alloc] init];
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
