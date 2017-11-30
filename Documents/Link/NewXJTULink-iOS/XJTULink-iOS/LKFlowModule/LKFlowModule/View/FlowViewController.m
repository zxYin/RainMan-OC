//
//  FlowViewController.m
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FlowViewController.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "PNChart.h"
#import "FlowItemCell.h"
#import "FlowViewModel.h"
#import "LKSimpleTextBar.h"
#import "NetChargeViewController.h"

const CGFloat FlowHeaderViewHeight = 180;
@interface FlowViewController()<UITableViewDelegate, UITableViewDataSource> {
    BOOL _shouldUpdate;
}
@property (nonatomic, copy) FlowViewModel *viewModel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *headerView;
@property (strong,nonatomic) PNLineChart *flowChart;
@property (nonatomic, strong) LKSimpleTextBar *netChargeBar;

@end
@implementation FlowViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    [self.view addSubview:self.tableView];
    
    
    [self.headerView addSubview:self.flowChart];
    
    [self.flowChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(170);
        make.left.mas_equalTo(self.headerView);
        make.right.mas_equalTo(self.headerView);
        make.bottom.mas_equalTo(self.headerView);
    }];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.netChargeBar];
    
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(FlowHeaderViewHeight, 0, LKSimpleTextBarHeight, 0);
    [self.netChargeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(LKSimpleTextBarHeight);
    }];
    
    [self setupRAC];
    
    [self.viewModel.networkingRAC.requestCommand execute:nil];
    [self.activityIndicatorView startAnimating];

}

- (void)setupRAC {
    @weakify(self);
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         [RKDropdownAlert title:@"网络错误"];
     }];
    
    [RACObserve(self.viewModel, itemValues) subscribeNext:^(id x) {
        @strongify(self);
        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, flowHistory) subscribeNext:^(id x) {
        @strongify(self);
        [self.flowChart setXLabels:self.viewModel.timeTitles];
        PNLineChartData *chartData = [PNLineChartData new];
        chartData.color = [UIColor whiteColor];
        chartData.itemCount = self.viewModel.flowHistory.count;
        chartData.inflexionPointStyle = PNLineChartPointStyleTriangle;
        
        chartData.getData = ^(NSUInteger index) {
            CGFloat yValue = [self.viewModel.flowHistory[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        self.flowChart.chartData = @[chartData];
        [self.flowChart strokeChart];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.itemTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kFlowItemCellIdentifier];
    cell.titleLabel.text = self.viewModel.itemTitles[indexPath.row];
    cell.valueLabel.text = self.viewModel.itemValues[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if(offset < - 190) {
        self.activityIndicatorView.hidesWhenStopped = NO;
        if(!self.activityIndicatorView.isAnimating) {
            [[self.activityIndicatorView subviews] firstObject].transform =
            CGAffineTransformMakeRotation(2 * M_PI * fabs(offset + 180) / 180);
            
            if (offset < - 300) {
                [self.activityIndicatorView startAnimating];
                [self.viewModel.networkingRAC.requestCommand execute:@(YES)];
            }
        }
    } else {
        self.activityIndicatorView.hidesWhenStopped = YES;
    }

    
    if (offset < - FlowHeaderViewHeight) {
        CGRect frame = self.headerView.frame;
        frame.size.height = fabs(offset);
        frame.origin.y = 0;
        self.headerView.frame = frame;
    } else {
        CGRect frame = self.headerView.frame;
        frame.origin.y = -(FlowHeaderViewHeight + offset);
        frame.size.height = FlowHeaderViewHeight;
        self.headerView.frame = frame;
    }
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        
        UINib *nib = [UINib nibWithNibName:@"FlowItemCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:kFlowItemCellIdentifier];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, FlowHeaderViewHeight)];
        _headerView.backgroundColor = LKColorLightBlue;
    }
    return _headerView;
}

- (FlowViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [FlowViewModel new];
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

- (PNLineChart *)flowChart {
    if (_flowChart == nil) {
        _flowChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width,170)];
        _flowChart.backgroundColor = [UIColor clearColor];
        _flowChart.xLabelColor = [UIColor whiteColor];
        _flowChart.yLabelColor = [UIColor whiteColor];
        _flowChart.axisColor = [UIColor whiteColor];
        _flowChart.showCoordinateAxis = YES;
        
        _flowChart.yValueMax = 16;
        _flowChart.chartMarginBottom = 20;
    }
    return _flowChart;
}

- (LKSimpleTextBar *)netChargeBar {
    if (_netChargeBar == nil) {
        @weakify(self);
        _netChargeBar = [LKSimpleTextBar simpleTextBarWithBlock:^{
            @strongify(self);
            NetChargeViewController *vc = [[NetChargeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_netChargeBar.button setTitle:@"缴网费" forState:UIControlStateNormal];
    }
    return _netChargeBar;
}

@end
