//
//  TeachingEvaluationViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TeachingEvaluationViewController.h"
#import "ViewsConfig.h"
#import "TeachingEvaluationViewModel.h"
#import "EvaluationCourseItemCell.h"
#import "EvaluationEditViewController.h"
@interface TeachingEvaluationViewController ()<UITableViewDelegate, UITableViewDataSource,LKEmptyManagerDelegate>
@property (nonatomic, strong) TeachingEvaluationViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation TeachingEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教学评价";
    
    self.tableView.mj_header =
    [MJRefreshNormalHeader headerWithRefreshingCommand:[self.viewModel.networkingRAC requestCommand]];

    [self setupRAC];
    
    self.tableView.tableFooterView = [UIView new];
    UINib *nib = [UINib nibWithNibName:@"EvaluationCourseItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[EvaluationCourseItemCell lk_identifier]];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRAC {
    self.tableView.tableHeaderView.hidden = YES;
    @weakify(self);
    [[RACObserve(self.viewModel, notice) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        self.tableView.tableHeaderView.hidden = NO;
        self.noticeLabel.text = self.viewModel.notice;
        [UIView animateWithDuration:0.5 animations:^{
            [self adjustTableViewHeight];
        }];
    }];

    [[RACObserve(self.viewModel, courseViewModels) skip:1]
     subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        [self.emptyManager reloadEmptyDataSet];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(YLResponseError *error) {
         @strongify(self);
         [self.emptyManager reloadEmptyDataSet];
         [AppContext showProgressFailHUDWithMessage:error.message];
         [self.tableView.mj_header endRefreshing];
     }];
    
}

- (void)adjustTableViewHeight {
    
    UIView *headerView = self.tableView.tableHeaderView;

    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    __block CGFloat maxHeight = 0;
    [[headerView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxHeight < obj.frame.origin.y) {
            maxHeight = obj.frame.origin.y + obj.frame.size.height;
        }
    }];
    NSLog(@"maxHeight: %f",maxHeight);
    CGRect frame = headerView.frame;
    frame.size.height = maxHeight;
    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
    self.emptyManager.verticalOffset = headerView.frame.size.height / 2.0;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.courseViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluationCourseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[EvaluationCourseItemCell lk_identifier] forIndexPath:indexPath];
    
    EvaluationCourseViewModel *viewModel = self.viewModel.courseViewModels[indexPath.row];
    cell.titleLabel.text = viewModel.name;
    cell.timesLabel.text = [NSString stringWithFormat:@"已评%td次",viewModel.count];
    cell.teacherLabel.text = viewModel.teacher;
    cell.typeLabel.text = viewModel.type;
    RAC(cell.statusLabel, hidden) = [[RACObserve(viewModel, isEvluted) not] takeUntil:cell.rac_prepareForReuseSignal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EvaluationCourseItemCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EvaluationCourseViewModel *courseViewModel = self.viewModel.courseViewModels[indexPath.row];
    
    if (courseViewModel.isEvluted) {
        [AppContext showProgressFailHUDWithMessage:@"一周只能评一次啦！"];
        return;
    }
    
    EvaluationEditViewModel *viewModel = [[EvaluationEditViewModel alloc] initWithTargets:self.viewModel.targets[courseViewModel.type]];
    viewModel.courseViewModel = courseViewModel;
    EvaluationEditViewController *vc = [[EvaluationEditViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}


- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
        _emptyManager.delegate = self;
    }
    return _emptyManager;
}


- (TeachingEvaluationViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TeachingEvaluationViewModel alloc] init];
    }
    return _viewModel;
}
@end
