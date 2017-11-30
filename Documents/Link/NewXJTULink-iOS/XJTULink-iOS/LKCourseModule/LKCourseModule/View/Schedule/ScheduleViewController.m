//
//  ScheduleViewController.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleEditViewController.h"
#import "ScheduleListViewModel.h"
#import "ScheduleItemViewModel.h"
#import "ScheduleEditViewModel.h"
#import "ScheduleItemCell.h"
#import "ViewsConfig.h"
#import "AppContext.h"

@interface ScheduleViewController ()<UITableViewDelegate, UITableViewDataSource, LKEmptyManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ScheduleListViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"考试安排";
    
    self.emptyManager.title = @"听说你没有考试了？";
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        @strongify(self);
        ScheduleEditViewModel *viewModel = [[ScheduleEditViewModel alloc] initWithType:ScheduleEditViewModelTypeAdd];
        ScheduleEditViewController *vc = [[ScheduleEditViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setupRAC];
    
    UINib *nib = [UINib nibWithNibName:@"ScheduleItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ScheduleItemCell lk_identifier]];
    
    if (self.viewModel.scheduleItemViewModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)setupRAC {
    @weakify(self);
    [[[RACObserve(self.viewModel, scheduleItemViewModels) skip:1]
     deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(id x) {
        @strongify(self);
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
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.scheduleItemViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScheduleItemCell lk_identifier] forIndexPath:indexPath];
    
    ScheduleItemViewModel *viewModel = self.viewModel.scheduleItemViewModels[indexPath.row];
    cell.viewModel = viewModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScheduleItemCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleEditViewModel *viewModel = [[ScheduleEditViewModel alloc] initWithType:ScheduleEditViewModelTypeUpdate];
    viewModel.scheduleModel.eventId = self.viewModel.scheduleItemViewModels[indexPath.row].eventId;
    viewModel.scheduleModel.name = self.viewModel.scheduleItemViewModels[indexPath.row].name;
    NSString *locale = self.viewModel.scheduleItemViewModels[indexPath.row].locale;
    if ([locale isEqualToString:@"(未设置)"]) {
        locale = @"";
    }
    viewModel.scheduleModel.locale = locale;
    
    viewModel.scheduleModel.time = self.viewModel.scheduleItemViewModels[indexPath.row].time;
    
    ScheduleEditViewController *vc = [[ScheduleEditViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel.scheduleItemViewModels[indexPath.row].networkingRAC.requestCommand execute:nil];
        [self.viewModel.scheduleItemViewModels[indexPath.row] deleteLocalArchive];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.allowsSelection = YES;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:[self.viewModel.networkingRAC requestCommand]];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (ScheduleListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ScheduleListViewModel alloc] init];
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
