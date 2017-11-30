//
//  CommunityViewContoller.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "CommunityViewContoller.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "LKPostListViewModel.h"
#import "LKAnonymousPostCell.h"
#import "LKPostMessageHeader.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Foundation+LKTools.h"
#import "LKPostDetailViewContoller.h"
#import "YPMenuController.h"
#import "LKPostEditViewController.h"
#import "LKPostCell.h"
#import "CommunityContext.h"
#import "LKMessageViewController.h"
#import "LKPermissionManager.h"
#import "NSUserDefaults+LKTools.h"

@interface CommunityViewContoller()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) YPMenuController *menuController;
@property (nonatomic, strong) LKPostListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CommunityViewContoller

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithContext:(CommunityContext *)context {
    self = [super init];
    if (self) {
        [CommunityContext setupCurrentContext:context];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([LKUserDefaults boolForKey:LKUserDefaultsFirstEnterCommunity defaultValue:YES]) {
        [[LKPermissionManager sharedInstance] checkNotificationPermission];
        [LKUserDefaults setBool:NO forKey:LKUserDefaultsFirstEnterCommunity];
    }
    
    CommunityContext *context = [CommunityContext currentContext];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:context.tintColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [context.options firstObject].title;
    
    [self setupRAC];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        @strongify(self);
        LKPostEditViewController *vc = [[LKPostEditViewController alloc] init];
        [vc setDidSubmitBlock:^(LKPostModel *model) {
            [self.viewModel insertModel:model];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.menuController.view];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    context.currentOption = [context.options firstObject];
}


- (void)setupRAC {
    @weakify(self);
    
    [[[RACObserve(self.viewModel, confessionViewModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.viewModel.refreshMode.type == LKRefreshTypeIncrement) {
             [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
             return;
         }
         if (self.viewModel.refreshMode.type == LKRefreshTypeDecrement) {
             [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.viewModel.refreshMode.index] withRowAnimation:UITableViewRowAnimationBottom];
             return;
         }
         [self.tableView reloadData];
     }];
    
    [[RACObserve(self.viewModel, needEndRefresh) filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if (self.viewModel.hasNextPage) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.viewModel.needEndRefresh = NO;
    }];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         [RKDropdownAlert title:@"网络错误"];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
    
    
    LKPostMessageHeader *header = [LKPostMessageHeader headerView];
    header.frame = CGRectMake(0, 0, MainScreenSize.width, ConfessionNewsMessageHeaderHeight);
    [header.backgroundView bk_whenTapped:^{
        @strongify(self);
        CommunityContext *context = [CommunityContext currentContext];
        LKMessageViewController *vc = [[LKMessageViewController alloc] initWithCommunity:context.communityId option:context.currentOption.optionId tintColor:context.tintColor];
        self.viewModel.message = nil;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.tableView.tableHeaderView = header;
    
    [RACObserve(self.viewModel, message) subscribeNext:^(NSString *message) {
        @strongify(self);
        self.tableView.tableHeaderView.hidden = [NSString isBlank:message];
        ((LKPostMessageHeader *)self.tableView.tableHeaderView).messageCountLabel.text = message;
        [self adjustTableViewHeaderViewHeight];

    }];
    
    [RACObserve([CommunityContext currentContext], currentOption) subscribeNext:^(CommunityOption *type) {
        @strongify(self);
        
        NSString *title = type.title;
        UIButton *titleButton = [UIButton buttonWithType: UIButtonTypeSystem];
        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleButton setImage:[UIImage imageNamed:@"nav_dropdown_normal"]
                     forState:UIControlStateNormal];
        
        titleButton.imageView.contentMode = UIViewContentModeCenter;
        [titleButton setTitle: title forState: UIControlStateNormal];
        [titleButton sizeToFit];
        
        CGSize titleLabelSize = titleButton.titleLabel.intrinsicContentSize;
        titleButton.titleEdgeInsets =
        UIEdgeInsetsMake(0, -10, 0, 10);
        
        titleButton.imageEdgeInsets =
        UIEdgeInsetsMake(0, titleLabelSize.width + 10, 0, -10);
        
        [titleButton sizeToFit];
        
        [titleButton bk_whenTapped:^{
            @strongify(self);
            self.menuController.hidden = !self.menuController.hidden;
        }];
        
        [RACObserve(self.menuController, hidden) subscribeNext:^(id x) {
            if ([x boolValue]) {
                [titleButton setImage:[UIImage imageNamed:@"nav_dropdown_normal"]
                             forState:UIControlStateNormal];
            } else {
                [titleButton setImage:[UIImage imageNamed:@"nav_dropdown_close"] forState:UIControlStateNormal];
            }
        }];
        self.navigationItem.titleView = titleButton;
        
        if (type.allowPost) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
                @strongify(self);
                LKPostEditViewController *vc = [[LKPostEditViewController alloc] init];
                [vc setDidSubmitBlock:^(LKPostModel *model) {
                    [self.viewModel insertModel:model];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        [self.tableView.mj_header beginRefreshing];
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self adjustTableViewHeaderViewHeight];
    [self.menuController selectIndex:0];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel.networkingRAC.cancelCommand execute:nil];
}

- (void)adjustTableViewHeaderViewHeight {
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height =
    [NSString notBlank:self.viewModel.message] ? ConfessionNewsMessageHeaderHeight : 0;
    
    self.tableView.tableHeaderView.frame = headerFrame;
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKPostViewModel *viewModel = self.viewModel.confessionViewModels[indexPath.section];
    UITableViewCell *cell;
    if (viewModel.user) {
        LKPostCell *cCell = [tableView dequeueReusableCellWithIdentifier:LKPostCell.lk_identifier
                                                                    forIndexPath:indexPath];
        cCell.viewModel = viewModel;
        cell = cCell;
    } else {
        LKAnonymousPostCell *cCell = [tableView dequeueReusableCellWithIdentifier:LKAnonymousPostCell.lk_identifier
                                                                   forIndexPath:indexPath];
        cCell.viewModel = viewModel;
        cell = cCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.confessionViewModels count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKPostViewModel *viewModel = self.viewModel.confessionViewModels[indexPath.section];
    if (viewModel.user) {
        return [tableView fd_heightForCellWithIdentifier:LKPostCell.lk_identifier cacheByIndexPath:indexPath configuration:^(LKPostCell *cell) {
            cell.viewModel = viewModel;
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:LKAnonymousPostCell.lk_identifier cacheByIndexPath:indexPath configuration:^(LKAnonymousPostCell *cell) {
            cell.viewModel = viewModel;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKPostViewModel *viewModel = self.viewModel.confessionViewModels[indexPath.section];
    if (viewModel.isDeleted) {
        [AppContext showMessage:@"内容已被删除"];
        return;
    }
    LKPostDetailViewContoller *vc = [[LKPostDetailViewContoller alloc] initWithViewModel:viewModel];
    [vc setDidDeleteBlock:^(LKPostViewModel *viewModel) {
        viewModel.isDeleted = YES;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *anonymousPostNib = [UINib nibWithNibName:@"LKAnonymousPostCell" bundle:nil];
        [self.tableView registerNib:anonymousPostNib forCellReuseIdentifier:LKAnonymousPostCell.lk_identifier];
        
        UINib *postNib = [UINib nibWithNibName:@"LKPostCell" bundle:nil];
        [self.tableView registerNib:postNib forCellReuseIdentifier:LKPostCell.lk_identifier];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
        self.tableView.tableFooterView = [UIView new];
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        footer.triggerAutomaticallyRefreshPercent = 0;
        self.tableView.mj_footer = footer;
    }
    return _tableView;
}

- (LKPostListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LKPostListViewModel alloc] init];
    }
    return _viewModel;
}

- (YPMenuController *)menuController {
    if (_menuController == nil) {
        NSArray<NSString *> *types = [[CommunityContext currentContext].options bk_map:^id(CommunityOption *obj) {
            return obj.title;
        }];
        _menuController = [[YPMenuController alloc] initWithBlock:^(NSInteger index) {
            CommunityContext *context = [CommunityContext currentContext];
            context.currentOption = context.options[index];
        } initialSelections:0];
        _menuController.items = [types copy];
        _menuController.highlightedCellColor = [CommunityContext currentContext].tintColor;
    }
    return _menuController;
}

- (void)dealloc {
    NSLog(@"List dealloc");
}
@end
