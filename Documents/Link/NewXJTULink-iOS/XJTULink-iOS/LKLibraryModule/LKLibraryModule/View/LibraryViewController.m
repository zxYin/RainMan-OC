//
//  LibraryViewController.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryViewController.h"
#import "ViewsConfig.h"
#import "LibBookItemCell.h"
#import "LibraryViewModel.h"
#import "AppContext.h"
#import "LibraryHeader.h"
#import "LibraryLoginViewController.h"
#import "AppMediator+LKLibraryModule.h"
#import "LKPermissionManager.h"
#import "Macros.h"
#import "NSUserDefaults+LKTools.h"
//#import "LKUse"
@interface LibraryViewController () <UITableViewDelegate, UITableViewDataSource, LKEmptyManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) LibraryHeader *headerView;
@property (nonatomic, strong) LibraryViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"借阅信息(收取中...)";
    
    if ([LKUserDefaults boolForKey:LKUserDefaultsFirstEnterLibrary defaultValue:YES]) {
        [[LKPermissionManager sharedInstance] checkNotificationPermission];
        [LKUserDefaults setBool:NO forKey:LKUserDefaultsFirstEnterLibrary];
    }
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self.view addSubview:self.headerView];
    self.tableView.contentInset = UIEdgeInsetsMake(LibraryHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -LibraryHeaderHeight);
    
    UINib *nib = [UINib nibWithNibName:@"LibBookItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:LibBookItemCell.lk_identifier];
    
    RAC(self.headerView.fineLabel, text) = RACObserve(self.viewModel, fine);
    RAC(self.headerView.numberLabel, text) =
    [RACObserve(self.viewModel, libBookViewModels) map:^id(id value) {
        return [NSString stringWithFormat:@"%td",[value count]];
    }];
    
    @weakify(self);
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(YLResponseError *error) {
         @strongify(self);
         self.title = @"借阅信息";
         [self.tableView.mj_header endRefreshing];
         if(error.code == YLAPIManagerResponseStatusLibPasswordError) {
             [AppContext showError:error.message];
             
             UINavigationController *navController =
             [[AppContext sharedInstance] navigationControllerOfTabBarControllerAtItem:LKTabBarItemMine];
             LibraryLoginViewController *loginVC = [[LibraryLoginViewController alloc] initWithCallback:^{
                 LibraryViewController *vc = [[LibraryViewController alloc] init];
                 vc.hidesBottomBarWhenPushed = YES;
                 [navController pushViewController:vc animated:YES];
             }];
             UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginVC];
             [navController presentViewController:loginNavController animated:YES completion:nil];

         } else {
             [self.emptyManager reloadEmptyDataSet];
             [AppContext showProgressFailHUDWithMessage:error.message];
         }
     }];
    
    
    [self.viewModel.networkingRAC.executionSignal subscribeNext:^(id x) {
        self.title = @"借阅信息";
    }];
    
    
    [[[RACObserve(self.viewModel, libBookViewModels) skip:1]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         if (self.viewModel.libBookViewModels.count == 0) {
             [self.emptyManager reloadEmptyDataSet];
         }
    }];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headerView.frame = CGRectMake(0, 0, MainScreenSize.width, LibraryHeaderHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel.networkingRAC.requestCommand execute:@(YES)];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.libBookViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LibBookItemCell *cell = [tableView dequeueReusableCellWithIdentifier:LibBookItemCell.lk_identifier forIndexPath:indexPath];
    cell.viewModel = self.viewModel.libBookViewModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LibBookItemCellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < - LibraryHeaderHeight) {
        CGRect frame = self.headerView.frame;
        frame.size.height = fabs(offset);
        self.headerView.frame = frame;
    } else {
        CGRect frame = self.headerView.frame;
        frame.origin.y = -(LibraryHeaderHeight + offset);
        frame.size.height = LibraryHeaderHeight;
        self.headerView.frame = frame;
    }
}

#pragma mark - getter
- (LibraryViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [LibraryViewModel new];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (LibraryHeader *)headerView {
    if (_headerView == nil) {
        _headerView = [LibraryHeader libraryHeader];
    }
    return _headerView;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView,LKEmptyManagerStylePreview);
        _emptyManager.title = @"暂无借阅记录";
        _emptyManager.content = @"磋砣莫遗韶光老，人生惟有读书好。\n(点击重新查询)";
        _emptyManager.delegate = self;
        _emptyManager.verticalOffset = 30;
        _emptyManager.backgroundColor = [UIColor whiteColor];
        _emptyManager.allowTouch = YES;
    }
    return _emptyManager;
}
@end
