//
//  LKMessageViewController.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageViewController.h"
#import "ViewsConfig.h"
#import "LKMessageListViewModel.h"
#import "LKMessageManager.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AppMediator.h"
#import "Macros.h"
#import "LKInputToolBar.h"
#import "LKMessageReplyAPIManager.h"
#import "AppContext.h"
#import "LKMessageReplyAPIManager.h"
#import "RTRootNavigationController.h"
#import "LKPermissionManager.h"
#import "NSUserDefaults+LKTools.h"

@interface LKMessageViewController ()<UITableViewDelegate, UITableViewDataSource, LKInputToolBarDelegate>
@property (nonatomic, strong) LKMessageListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKInputToolBar *inputToolBar;
@property (nonatomic, strong) NSIndexPath *focusIndexPath;
@property (nonatomic, strong) UIColor *tintColor;
@end

@implementation LKMessageViewController
- (instancetype)initWithCommunity:(NSString *)community option:(NSString *)option tintColor:(UIColor *)tintColor {
    self = [super init];
    if (self) {
        _viewModel = [[LKMessageListViewModel alloc] initWithCommunity:community option:option];
        _tintColor = tintColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([LKUserDefaults boolForKey:LKUserDefaultsFirstEnterMessage defaultValue:YES]) {
        [[LKPermissionManager sharedInstance] checkNotificationPermissionWithMessage:@"通知权限未开放，您将无法收到相关消息的推送哦~"];
        [LKUserDefaults setBool:NO forKey:LKUserDefaultsFirstEnterMessage];
    }
    
    [self.navigationController.navigationBar lt_setBackgroundColor:self.tintColor];
    self.title = @"消息";
    
    [self setupRAC];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputToolBar];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)setupRAC {
    @weakify(self);
    [[[RACObserve(self.viewModel, messageList) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         if (self.viewModel.hasNextPage) {
             [self.tableView.mj_footer endRefreshing];
         } else {
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
         
     }];
    
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeReply] requestErrorSignal] subscribeNext:^(YLResponseError *error) {
        [AppContext showProgressFailHUDWithMessage:[NSString stringWithFormat:@"%@", error.message]];
    }];
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeReply] executionSignal] subscribeNext:^(YLResponseError *error) {
        @strongify(self);
        [AppContext showProgressFinishHUDWithMessage:@"回复成功"];
        [self.inputToolBar removeCurrentDraft];
    }];

    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeMessageList] requestErrorSignal]
     subscribeNext:^(NSError *error) {
         @strongify(self);
         [RKDropdownAlert title:@"网络错误"];
         [self.tableView.mj_header endRefreshing];
     }];

}



#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKMessage<LKMessage> *message = self.viewModel.messageList[indexPath.section];
    UITableViewCell<LKMessageCell> *cell =
    [tableView dequeueReusableCellWithIdentifier:[[message class] cellName]
                                    forIndexPath:indexPath];
    [cell configWithModel:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
//    CGRect cellRect = cell.frame
    
    @weakify(self);
    if ([cell respondsToSelector:@selector(setReplyButtonDidClickBlock:)]) {
        [cell setReplyButtonDidClickBlock:^(LKMessage *message, NSString *placeholder) {
           //show input bar
            @strongify(self);
//            [self.tableView lk_scrollToRowAtIndexPathWhenKeyboradAppear:indexPath];
            self.focusIndexPath = indexPath;
            [self.inputToolBar becomeFirstResponder];
            
            if ([NSString notBlank:placeholder]) {
                self.inputToolBar.inputTextView.placeholder = placeholder;
            }
            self.inputToolBar.draftKey = LKTextViewDraftKey(@"message",message.messageId);
        }];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.messageList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKMessage<LKMessage> *message = self.viewModel.messageList[indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:[[message class] cellName] cacheByIndexPath:indexPath configuration:^(UITableViewCell<LKMessageCell> *cell) {
        [cell configWithModel:message];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKMessage *message = self.viewModel.messageList[indexPath.section];
    [[AppMediator sharedInstance] performActionWithURL:message.command];
}

#pragma mark - LKInputToolBarDelegate
- (void)inputToolBar:(LKInputToolBar *)inputToolBar returnButtonDidClickWithText:(NSString *)text {
//    NSLog(@"发送！！！");
    [AppContext showProgressLoading];
    LKMessage<LKMessage> *message = self.viewModel.messageList[self.focusIndexPath.section];
    self.viewModel.replyMessageId = message.messageId;
    self.viewModel.replyContent = text;
    [[self.viewModel.networkingRACs[kNetworkingRACTypeReply] requestCommand] execute:nil];
}

- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidBeginEditing:(NSString *)text {
    self.rt_navigationController.interactivePopGestureRecognizer.enabled = NO;
    CGPoint offset = self.tableView.contentOffset;
    CGRect inputRect = [self.inputToolBar convertRect:[self.inputToolBar inputFieldRect] toView:self.view];
    CGRect rect = [self.tableView rectForRowAtIndexPath:self.focusIndexPath];
    CGRect cRect = [self.tableView convertRect:rect toView:self.view];
    offset.y -= CGRectGetMinY(inputRect) - CGRectGetMaxY(cRect);
    if (offset.y > 0) {
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidEndEditing:(NSString *)text {
    self.rt_navigationController.interactivePopGestureRecognizer.enabled = YES;
    CGPoint offset = self.tableView.contentOffset;
    CGFloat maxOffsetY = MAX(self.tableView.contentSize.height - self.tableView.frame.size.height, 0);
    if (offset.y  > maxOffsetY) {
        offset.y = maxOffsetY;
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xefeff4);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [[LKMessageManager sharedInstance] configTableViewRegisters:self.tableView];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:
                                 [self.viewModel.networkingRACs[kNetworkingRACTypeMessageList] refreshCommand]];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:[self.viewModel.networkingRACs[kNetworkingRACTypeMessageList] requestNextPageCommand]];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        footer.automaticallyHidden = YES;
        self.tableView.mj_footer = footer;
        
        
    }
    return _tableView;
}

- (LKMessageListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LKMessageListViewModel alloc] init];
    }
    return _viewModel;
}


- (LKInputToolBar *)inputToolBar {
    if (_inputToolBar == nil) {
        _inputToolBar = [LKInputToolBar inputToolBar];
        _inputToolBar.frame = CGRectMake(0, 0, MainViewSize.width, MainViewSize.height);
        _inputToolBar.delegate = self;
        _inputToolBar.resident = NO;
        _inputToolBar.maxLength = 300;
    }
    return _inputToolBar;
}

- (UIColor *)tintColor {
    if (_tintColor == nil) {
        _tintColor = LKColorLightBlue;
    }
    return _tintColor;
}
@end
