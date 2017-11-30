//
//  ClubListViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubListViewController.h"
#import "ViewsConfig.h"
#import "ClubItemCell.h"
#import "ClubViewController.h"
#import "LKSearchViewController.h"
#import "ClubClassifyHeader.h"
#import "LKWebBrowser.h"
#import "LKSharePanel.h"
@interface ClubListViewController ()<UITableViewDelegate, UITableViewDataSource, ClubItemCellDelegate,ClubClassifyHeaderDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClubListViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@property (nonatomic, strong) ClubClassifyHeader *clubClassifyHeader;
@end

@implementation ClubListViewController
- (instancetype)initWithViewModel:(ClubListViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团/组织";
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *searchItem =
    [[UIBarButtonItem alloc]
     bk_initWithImage:[UIImage imageNamed:@"icon_search_button"]
     style:UIBarButtonItemStyleDone handler:^(id sender) {
         LKSearchViewController *vc = [[LKSearchViewController alloc] initWithPlaceholder:@"搜一下吧"];
         vc.animateEnable = YES;
         [self.navigationController pushViewController:vc animated:NO];
     }];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self setupRAC];
    
    [self.view addSubview:self.tableView];
    
    
    __block NSInteger currentIndex = 0;
    [self.viewModel.clubTypes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[kClubTypeKeyId] isEqualToString:self.viewModel.currentTypeId]) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    self.clubClassifyHeader.selectIndex = currentIndex;
    self.clubClassifyHeader.delegate = self;
    [self.view addSubview:self.clubClassifyHeader];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ClubClassifyHeaderHeight, 0, 0, 0));
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRAC {
    @weakify(self);
    
    [[[RACObserve(self.viewModel, clubViewModels) skip:1]
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
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];

    
    RAC(self.clubClassifyHeader, backgroundColor) = RACObserve(self.tableView, backgroundColor);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel.networkingRAC.cancelCommand execute:nil];
}


- (void)clubClassifyHeader:(ClubClassifyHeader *)header didTapIndex:(NSInteger)index {
    self.viewModel.currentTypeId = self.viewModel.clubTypes[index][kClubTypeKeyId];
    [self.tableView.mj_header beginRefreshing];
}

- (void)clubItemCell:(ClubItemCell *)cell shareButtonDidClick:(id)sender {
    LKShareModel *model = cell.viewModel.shareModel;
    model.image = cell.clubImageView.image;
    LKSharePanel *panel = [[LKSharePanel alloc] initWithShareModel:model];
    panel.title = [NSString stringWithFormat:@"邀请好友加入%@吧！",cell.viewModel.name];
    [panel show];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ClubItemCellIdentifier
                                                         forIndexPath:indexPath];
    ClubViewModel *viewModel = self.viewModel.clubViewModels[indexPath.row];
    cell.viewModel =viewModel;
    cell.delegate = self;
//    if (self.lk_forceTouchAvailable) {
//        [self registerForPreviewingWithDelegate:self sourceView:cell];
//    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.clubViewModels count];
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


//#pragma mark - UIViewControllerPreviewingDelegate
//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
//    ClubViewModel *viewModel = self.viewModel.clubViewModels[indexPath.row];
//    UIViewController *vc;
//    if (viewModel.showType == kPageShowTypeWeb) {
//        vc = [LKWebBrowser webBrowserWithURL:viewModel.webURL title:viewModel.name];
//    } else {
//        vc = [[ClubViewController alloc] initWithViewModel:viewModel];
//    }
//    return vc;
//}
//
//- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
//     commitViewController:(UIViewController *)viewControllerToCommit {
//    [self showViewController:viewControllerToCommit sender:self];
//}


#pragma mark - getter && setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = ClubItemCellHeight;
        
        UINib *clubNib = [UINib nibWithNibName:@"ClubItemCell" bundle:nil];
        [_tableView registerNib:clubNib forCellReuseIdentifier:ClubItemCellIdentifier];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"没啦~ 被看光啦 (*/ω＼*)" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        _tableView.mj_footer = footer;
        
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
    }
    return _emptyManager;
}

- (ClubClassifyHeader *)clubClassifyHeader {
    if (_clubClassifyHeader == nil) {
        _clubClassifyHeader = [[ClubClassifyHeader alloc] initWithTypes:self.viewModel.clubTypes];
    }
    return _clubClassifyHeader;
}

@end
