//
//  LKCardViewController.m
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CardViewController.h"
#import "ViewsConfig.h"
#import "CardHeaderView.h"
#import "CardRecordItemCell.h"
#import "CardViewModel.h"
#import "ColorMacros.h"
#import "LKSimpleTextBar.h"
#import "TransferViewController.h"

@interface CardViewController ()<LKEmptyManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) CardHeaderView *headerView;
@property (nonatomic, strong) LKSimpleTextBar *transferBar;
@property (nonatomic, strong) CardViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"校园卡";
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.transferBar];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(CardHeaderViewHeight, 0, LKSimpleTextBarHeight, 0);
    
    [self.transferBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(LKSimpleTextBarHeight);
    }];
    
    [self setupRAC];
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeCardRecord] refreshCommand] execute:nil];
    [[self.viewModel.networkingRACs[kNetworkingRACTypeBalance] requestCommand] execute:nil];
    
    
    [self.activityIndicatorView startAnimating];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headerView.frame = CGRectMake(0, 0, MainScreenSize.width, CardHeaderViewHeight);
}


- (void)setupRAC {
    @weakify(self);
    [[[RACObserve(self.viewModel, cardRecordViewModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self.activityIndicatorView stopAnimating];
         if(self.viewModel.cardRecordViewModels.count == 0) {
             [self.emptyManager reloadEmptyDataSet];
         }
     }];
    
    RAC(self.headerView.balanceLabel, text) = RACObserve(self.viewModel, balance);
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.cardRecordViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[CardRecordItemCell lk_identifier]
                                                               forIndexPath:indexPath];
    CardRecordViewModel *viewModel = self.viewModel.cardRecordViewModels[indexPath.row];
    cell.timeLabel.text = viewModel.time;
    cell.amountLabel.text = viewModel.amount;
    if([viewModel.amount floatValue] < 0) {
        cell.amountLabel.textColor = [UIColor redColor];
    } else {
        cell.amountLabel.textColor = [UIColor blueColor];
    }
    cell.weekdayLabel.text = viewModel.weekday;
    cell.localeLabel.text = viewModel.locale;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CardRecordItemCellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if(offset < - (CardHeaderViewHeight + 10)) {
        self.activityIndicatorView.hidesWhenStopped = NO;
        if(!self.activityIndicatorView.isAnimating) {
            [[self.activityIndicatorView subviews] firstObject].transform =
            CGAffineTransformMakeRotation(2 * M_PI * fabs(offset+180) / 180);
            
            if (offset < -300 ) {
                [self.activityIndicatorView startAnimating];
                [[self.viewModel.networkingRACs[kNetworkingRACTypeCardRecord] refreshCommand] execute:@(YES)];
                [[self.viewModel.networkingRACs[kNetworkingRACTypeBalance] requestCommand] execute:@(YES)];
            }
        }
    } else {
        self.activityIndicatorView.hidesWhenStopped = YES;
    }
    
    if (offset < - CardHeaderViewHeight) {
        CGRect frame = self.headerView.frame;
        frame.size.height = fabs(offset);
        frame.origin.y = 0;
        self.headerView.frame = frame;
    } else {
        CGRect frame = self.headerView.frame;
        frame.origin.y = -(CardHeaderViewHeight + offset);
        frame.size.height = CardHeaderViewHeight;
        self.headerView.frame = frame;
    }
}

- (void)emptyManager:(LKEmptyManager *)manager didTapView:(UIView *)view {
    [self.activityIndicatorView startAnimating];
    [[self.viewModel.networkingRACs[kNetworkingRACTypeCardRecord] refreshCommand] execute:@(YES)];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [UIView new];
        
        UINib *nib = [UINib nibWithNibName:@"CardRecordItemCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:[CardRecordItemCell lk_identifier]];
        
    }
    return _tableView;
}

- (CardViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[CardViewModel alloc] init];
    }
    return _viewModel;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.layer.anchorPoint = CGPointMake(0.5,0.5);
        
    }
    return _activityIndicatorView;
}

- (CardHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [CardHeaderView cardHeaderView];
        _headerView.backgroundColor = LKColorLightBlue;
    }
    return _headerView;
}

- (LKSimpleTextBar *)transferBar {
    if (_transferBar == nil) {
        @weakify(self);
        _transferBar = [LKSimpleTextBar simpleTextBarWithBlock:^{
            @strongify(self);
            TransferViewController *vc = [[TransferViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_transferBar.button setTitle:@"在线圈存" forState:UIControlStateNormal];
    }
    return _transferBar;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView,LKEmptyManagerStylePreview);
        _emptyManager.title = @"暂无消费记录";
        _emptyManager.content = @"记得按时吃饭哦！\n(点击重新查询)";
        _emptyManager.delegate = self;
        _emptyManager.verticalOffset = 30;
        _emptyManager.backgroundColor = [UIColor whiteColor];
        _emptyManager.allowTouch = YES;
    }
    return _emptyManager;
}
@end
