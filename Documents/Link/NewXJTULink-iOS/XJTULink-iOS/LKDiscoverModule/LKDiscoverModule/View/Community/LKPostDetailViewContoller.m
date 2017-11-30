//
//  ConfessionDetailViewContoller.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostDetailViewContoller.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "LKCommentCell.h"
#import "LKAnonymousPostDetailCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIImageView+LKTools.h"
#import "UIImageView+AFNetworking.h"
#import "LKCommentListViewModel.h"
#import "LKInputToolBar.h"
#import "LKCommentMosaicCell.h"
#import "LKPostAPIManager.h"
#import "UIView+YLAutoLayoutHider.h"
#import "LKCommentAPIManager.h"
#import "LKCommentModel.h"
#import "User.h"
#import "ReferEditViewController.h"
#import "LKAvatarsView.h"
#import "LKPostDetailCell.h"
#import "CommunityContext.h"
#import "Chameleon.h"
#import "Foundation+LKTools.h"
#import "RTRootNavigationController.h"
typedef NS_ENUM(NSInteger, ExitMode){
    ExitModeDefault, // 正常退出
    ExitModeDelete,  // 删除后退出
};

@interface LKPostDetailViewContoller ()<UITableViewDelegate, UITableViewDataSource,LKInputToolBarDelegate,YLAPIManagerDelegate, YLAPIManagerDataSource,LKEmptyManagerDelegate>
@property (nonatomic, strong) LKPostViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKCommentListViewModel *commentListViewModel;
@property (nonatomic, strong) LKInputToolBar *inputToolBar;
@property (nonatomic, strong) NSIndexPath *focusPath;
@property (nonatomic, strong) NSArray *commentAPIManager;
@property (nonatomic, strong) LKEmptyManager *emptyManager;
@property (nonatomic, assign) ExitMode exitMode;
@property (nonatomic, assign) BOOL isSecretWord;

@property (nonatomic, strong) LKPostAPIManager *updateAPIManager;
@property (nonatomic, strong) LKPostAPIManager *referAPIManager;

@property (nonatomic, copy) NSDictionary *referStudent;
@end

@implementation LKPostDetailViewContoller

- (instancetype)initWithViewModel:(LKPostViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[CommunityContext currentContext].tintColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    self.exitMode = ExitModeDefault;
    [self setupRAC];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, [self.inputToolBar heightOfToolBar], 0));
    }];
    
    
    [self.view addSubview:self.inputToolBar];

    [self.inputToolBar.rightCheckButton yl_setHidden:YES forType:YLHiddenTypeVertical mode:YLPositionModeTotal];
    self.isSecretWord = NO;
    @weakify(self);
    [self.inputToolBar setRightCheckButtonActionBlock:^(UIButton *button){
        @strongify(self);
        self.isSecretWord = !self.isSecretWord;
        button.selected = self.isSecretWord;
        if (button.selected) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(-1,3,1,-3)];
            
            [button setImage:[UIImage imageNamed:@"wall_checked"] forState:UIControlStateNormal];
        }else {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
            [button setImage:[UIImage imageNamed:@"wall_uncheck"] forState:UIControlStateNormal];
        }
    }];
    
    switch (self.viewModel.relation) {
        case LKPostReleationAuthor: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"wall_delete"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
                actionSheet.title = @"删除这条表白后将无法恢复";
                [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
                    [AppContext showProgressLoading];
                    [self.updateAPIManager loadData];
                }];
                [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
                [actionSheet show];
            }];
            break;
        }
        case LKPostReleationTarget: {
            if (self.viewModel.accepted) {
                break;
            }
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"接受" style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
                actionSheet.title = @"拉勾上吊一百年不许变！（接受后将无法撤销哦~）";
                [actionSheet addButtonWithTitle:@"接受" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
                    [AppContext showProgressLoading];
                    [self.updateAPIManager loadData];
                }];
                [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
                [actionSheet show];
            }];
            break;
        }
        default:
            break;
    }
    
    if (self.viewModel.needRefresh) {
        [AppContext showProgressLoading];
        [self.viewModel.networkingRAC.requestCommand execute:nil];
        self.inputToolBar.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    } else {
        [self.tableView.mj_footer beginRefreshing];
        
    }
}

- (void)setupRAC {
    @weakify(self);
    [[[RACObserve(self.commentListViewModel, commentViewModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.commentListViewModel.commentViewModels count] == 0) {
             self.tableView.tableFooterView = [self emptyFooterView];
         } else {
             self.tableView.tableFooterView = [UIView new];
         }
         
         // 少于5条评论将不展示“没有更多评论了”
         self.tableView.mj_footer.hidden =
         [self.commentListViewModel.commentViewModels count] < 5;
         
         
         if (self.commentListViewModel.refreshMode.type == LKRefreshTypeIncrement) {
             [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationBottom];
             return;
         }
         if (self.commentListViewModel.refreshMode.type == LKRefreshTypeDecrement) {
             [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.commentListViewModel.refreshMode.index inSection:2]] withRowAnimation:UITableViewRowAnimationBottom];
             return;
         }
         [self.tableView reloadData];
         
         if (self.commentListViewModel.hasNextPage) {
             [self.tableView.mj_footer endRefreshing];
         } else {
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }

     }];
    
    [RACObserve(self.viewModel, likeCount) subscribeNext:^(NSNumber *likeCount) {
        @strongify(self);
        if ([likeCount integerValue] < 2) {
            [self.tableView reloadData];
        }
    }];
    
    [RACObserve(self.viewModel, accepted) subscribeNext:^(NSNumber *accepted) {
        @strongify(self);
        if (self.viewModel.relation == LKPostReleationTarget) {
            if (accepted) {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    }];
    
    [[RACObserve(self.viewModel, content) skip:1] subscribeNext:^(NSString *content) {
        @strongify(self);
        [AppContext dismissProgressLoading];
        self.view.backgroundColor = [UIColor whiteColor];
        self.inputToolBar.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        self.viewModel.needRefresh = NO;
        [self.tableView.mj_footer beginRefreshing];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.networkingRAC.requestErrorSignal subscribeNext:^(NSError *error) {
        @strongify(self);
        if (error.code == YLAPIManagerResponseStatusEntityNotExist) {
            [AppContext dismissProgressLoading];
            self.emptyManager.content = @"该表白不存在";
            self.emptyManager.allowTouch = NO;
        }else {
            [AppContext showProgressFailHUDWithMessage:@"网络出错"];
            self.emptyManager.content = @"哎呀，网络好像出错啦！\n(点击再试一下)";
            self.emptyManager.allowTouch = YES;
        }
        self.view.backgroundColor = LKEmptyManagerBackgroundColorDefault;
        [self.emptyManager reloadEmptyDataSet];
    }];
    [self.commentListViewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         [RKDropdownAlert title:@"网络错误"];
         self.tableView.tableFooterView = [self emptyFooterView];
         [self.tableView.mj_footer endRefreshingWithNoMoreData];
     }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.commentListViewModel.networkingRAC.cancelCommand execute:nil];
    if (self.exitMode == ExitModeDelete) {
        if (self.didDeleteBlock && ![self.viewModel isEmpty]) {
            self.didDeleteBlock(self.viewModel);
        }
    }
}

#pragma mark - LKInputToolBar delegate 
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidBeginEditing:(NSString *)text {
    self.rt_navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (!self.focusPath) {
        [self.inputToolBar.rightCheckButton yl_setHidden:NO forType:YLHiddenTypeVertical mode:YLPositionModeTotal];
        return;
    }
    CGPoint offset = self.tableView.contentOffset;
    CGRect inputRect = [self.inputToolBar convertRect:[self.inputToolBar inputFieldRect] toView:self.view];
    CGRect rect = [self.tableView rectForRowAtIndexPath:self.focusPath];
    CGRect cRect = [self.tableView convertRect:rect toView:self.view];
    offset.y -= CGRectGetMinY(inputRect) - CGRectGetMaxY(cRect);
    if (offset.y > 0) {
        [self.tableView setContentOffset:offset animated:YES];
    }
}
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidEndEditing:(NSString *)text {
    self.rt_navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.inputToolBar.inputTextView.placeholder = @"评论";
    self.inputToolBar.inputTextView.text = @"";
    CGPoint offset = self.tableView.contentOffset;
    CGFloat maxOffsetY = MAX(self.tableView.contentSize.height - self.tableView.frame.size.height + [self.inputToolBar heightOfToolBar], 0);
    if (offset.y  > maxOffsetY) {
        offset.y = maxOffsetY;
        [self.tableView setContentOffset:offset animated:YES];
    }
    [self.inputToolBar.rightCheckButton yl_setHidden:YES forType:YLHiddenTypeVertical mode:YLPositionModeTotal];
    self.focusPath = nil;
    self.isSecretWord = NO;
    
}
- (void)inputToolBar:(LKInputToolBar *)inputToolBar returnButtonDidClickWithText:(NSString *)text {
    inputToolBar.inputTextView.text = text;
    [AppContext showProgressLoading];
    [self.commentAPIManager[CommentAPIManagerTypeSubmit] loadData];
}

#pragma mark - UITableViewController delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.needRefresh) {
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        @weakify(self);
        if (self.viewModel.user) {
            return [tableView fd_heightForCellWithIdentifier:LKPostDetailCell.lk_identifier configuration:^(LKPostDetailCell *cell) {
                @strongify(self);
                LKPostViewModel *viewModel = self.viewModel;
                cell.viewModel = viewModel;
            }];
        }else {
            return [tableView fd_heightForCellWithIdentifier:LKAnonymousPostDetailCell.lk_identifier configuration:^(LKAnonymousPostDetailCell *cell) {
                @strongify(self);
                LKPostViewModel *viewModel = self.viewModel;
                cell.viewModel = viewModel;
            }];
        }
    }
    
    if (indexPath.section == 1) {
        if ([self.viewModel.likeUserAvatars count] == 0) {
            return 15;
        }else {
            return 50;
        }
    }
    
    LKCommentViewModel *tempCommentViewModel = self.commentListViewModel.commentViewModels[indexPath.row];
    if (tempCommentViewModel.type == CommentTypeMosaic) {
        return [tableView fd_heightForCellWithIdentifier:LKCommentMosaicCell.lk_identifier cacheByIndexPath:indexPath configuration:^(LKCommentMosaicCell *cell) {
            cell.viewModel = tempCommentViewModel;
        }];
    }
    return [tableView fd_heightForCellWithIdentifier:LKCommentCell.lk_identifier cacheByIndexPath:indexPath configuration:^(LKCommentCell *cell) {
        cell.viewModel = tempCommentViewModel;
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==2) {
        return [self.commentListViewModel.commentViewModels count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        id cell;
        if (self.viewModel.user) {
            cell = [tableView dequeueReusableCellWithIdentifier:LKPostDetailCell.lk_identifier
                                                                              forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:LKAnonymousPostDetailCell.lk_identifier
                                                   forIndexPath:indexPath];
        }
        [cell setViewModel:self.viewModel];
        @weakify(self);
        [cell setReferBlock:^(){
            ReferEditViewController *vc = [[ReferEditViewController alloc] init];
            @strongify(self);
            [vc setFinish:^(BOOL finish, NSString *referName, NSString *referAcademy, NSString *referClass) {
                if (finish) {
                    NSMutableDictionary *tempReferStudent = [[NSMutableDictionary alloc] init];
                    tempReferStudent[kPostAPIManagerParamsKeyReferAcademy] = referAcademy;
                    tempReferStudent[kPostAPIManagerParamsKeyReferClass] = referClass;
                    tempReferStudent[kPostAPIManagerParamsKeyReferName] = referName;
                    self.referStudent = [tempReferStudent copy];
                    [self.referAPIManager loadData];
                }
            }];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }];
    
        BOOL allowRefer = [CommunityContext currentContext].currentOption.allowRefer;
        [[cell referStudentBtn] yl_setHidden:(!allowRefer) forType:YLHiddenTypeHorizontal mode:YLPositionModeElimination];
        
        ((UITableViewCell *)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        return [self generateLikesCell];
    }
    LKCommentViewModel *tempCommentViewModel = self.commentListViewModel.commentViewModels[indexPath.row];
    if (tempCommentViewModel.type == CommentTypeMosaic) {
        LKCommentMosaicCell *cell = [tableView dequeueReusableCellWithIdentifier:LKCommentMosaicCell.lk_identifier
                                                                            forIndexPath:indexPath];
        cell.viewModel = tempCommentViewModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        LKCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LKCommentCell.lk_identifier
                                                                      forIndexPath:indexPath];
        
        
        cell.tintColor = [CommunityContext currentContext].tintColor;
        cell.viewModel = tempCommentViewModel;
        cell.viewModel.relation = [self makeCommentRelationForCommentViewModel:cell.viewModel];
        @weakify(self);
        [cell setCommentActionBlcok:^(LKCommentViewModel *viewModel) {
            @strongify(self);
            self.focusPath = indexPath;
            self.inputToolBar.inputTextView.placeholder =[NSString stringWithFormat:@"回复%@: ",viewModel.user.nickname];
            [self.inputToolBar becomeFirstResponder];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        return;
    }
    LKCommentViewModel *tempCommentViewModel = self.commentListViewModel.commentViewModels[indexPath.row];
    if (tempCommentViewModel.type == CommentTypeMosaic) {
        return;
    }
    self.focusPath = indexPath;
    TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
    actionSheet.title = @"";
    @weakify(self);
    if (tempCommentViewModel.relation != ConfessionCommentRelationAuthor) {
        [actionSheet addButtonWithTitle:(tempCommentViewModel.isLiked?@"取消赞":@"赞") style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            [tempCommentViewModel toggleLike];
        }];
    }
    [actionSheet addButtonWithTitle:@"回复" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self);
        if ([tempCommentViewModel.user.userId isEqualToString:[User sharedInstance].userId]) {
            self.inputToolBar.inputTextView.placeholder = @"评论";
            self.focusPath = nil;
            [self.inputToolBar becomeFirstResponder];
        }
        self.inputToolBar.inputTextView.placeholder =[NSString stringWithFormat:@"回复%@: ",tempCommentViewModel.user.nickname];
        [self.inputToolBar becomeFirstResponder];
    }];
    if ((self.viewModel.relation == LKPostReleationAuthor )
        || [tempCommentViewModel.user.userId isEqualToString:[User sharedInstance].userId]) {
        [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
            @strongify(self);
            TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
            actionSheet.title = @"确定删除这条评论吗？";
            [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
                [AppContext showProgressLoading];
                [self.commentAPIManager[CommentAPIManagerTypeDelete] loadData];
            }];
            [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
            [actionSheet show];
        }];
    }
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];

}
#pragma mark - network delegate & datasource
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    if (apiManager == self.commentAPIManager[CommentAPIManagerTypeSubmit]) {
        [AppContext showProgressFinishHUDWithMessage:@"回复成功"];
        [self.viewModel postComment];
        LKCommentModel *commentModel = [apiManager fetchDataFromModel:LKCommentModel.class];
        [self.commentListViewModel insertModel:commentModel];
        return;
    }
    if (apiManager == self.commentAPIManager[CommentAPIManagerTypeDelete]) {
        [AppContext showProgressFinishHUDWithMessage:@"删除成功"];
        [self.viewModel deleteComment];
        [self.commentListViewModel removeModelAtIndex:self.focusPath.row];
        return;
    }
    if (apiManager == self.referAPIManager) {
        [AppContext showProgressFinishHUDWithMessage:@"提醒成功"];
        return;
    }
    switch (self.viewModel.relation) {
        case LKPostReleationAuthor:
            self.exitMode = ExitModeDelete;
            [AppContext showProgressFinishHUDWithMessage:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case LKPostReleationTarget:
            [self.viewModel acceptConfession];
            [AppContext showProgressFinishHUDWithMessage:@"已接受"];
        default:
            break;
    }
}
- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    [AppContext showProgressFailHUDWithMessage:error.message];
    if (error.code == YLAPIManagerResponseStatusEntityNotExist) {
        self.viewModel.needRefresh = YES;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
        self.emptyManager.content = @"该表白不存在";
        self.emptyManager.allowTouch = NO;
        self.inputToolBar.hidden = YES;
        self.view.backgroundColor = LKEmptyManagerBackgroundColorDefault;
        [self.emptyManager reloadEmptyDataSet];
        
    }
    
}
- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (manager == self.commentAPIManager[CommentAPIManagerTypeSubmit]) {
        params[kCommentAPIManagerParamsKeyContent] = self.inputToolBar.inputTextView.text;
        params[kCommentAPIManagerParamsKeyConfessionId] = self.viewModel.postId;
        if (self.focusPath) {
            params[kCommentAPIManagerParamsKeyReferCommentId] = self.commentListViewModel.commentViewModels[self.focusPath.row].commentId;
        }
        if (self.isSecretWord) {
            params[kCommentAPIManagerParamsKeyOnlyAuthor] = @(self.isSecretWord);
        }
    } else if (manager == self.commentAPIManager[CommentAPIManagerTypeDelete]) {
        params[kCommentAPIManagerParamsKeyId] = self.commentListViewModel.commentViewModels[self.focusPath.row].commentId;
        return params;
    } else if (manager == self.referAPIManager) {
        params[kPostAPIManagerParamsKeyId] = self.viewModel.postId;
        if ([self.referStudent count]>0) {
            params[kPostAPIManagerParamsKeyReferName] = self.referStudent[kPostAPIManagerParamsKeyReferName];
            params[kPostAPIManagerParamsKeyReferClass] = self.referStudent[kPostAPIManagerParamsKeyReferClass];
            params[kPostAPIManagerParamsKeyReferAcademy] = self.referStudent[kPostAPIManagerParamsKeyReferAcademy];
        }
        return params;
    }
    params[kPostAPIManagerParamsKeyId] = self.viewModel.postId;
    return params;
}

#pragma mark - LKEmptyManagerDelegate
- (void)emptyManager:(LKEmptyManager *)manager didTapView:(UIView *)view {
    [AppContext showProgressLoading];
    [self.viewModel.networkingRAC.requestCommand execute:nil];
}


#pragma mark - configure cell
-(BOOL)navigationShouldPopOnBackButton {
    if (self.viewModel.relation != LKPostReleationTarget) {
        return YES;
    }
    if (self.viewModel.accepted) {
        return YES;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"target_confession_%@",self.viewModel.postId];
    NSDate *date = [userDefaults objectForKey:key];
    if (date) {
        if([date timeIntervalSinceNow]>-24*60*60) {
            return YES;
        }
    }
    TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
    actionSheet.title = @"这是对你的表白哦，不再考虑考虑吗？";
    [actionSheet addButtonWithTitle:@"确定" style:TBActionButtonStyleDefault];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    [userDefaults setObject:today forKey:key];
    return NO;
}

- (UITableViewCell *)generateLikesCell {
    UITableViewCell *likesCell = [[UITableViewCell alloc] init];
    UILabel *tintCommentLabel = [[UILabel alloc] init];
    tintCommentLabel.text = @"评论";
    [tintCommentLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [likesCell.contentView addSubview:tintCommentLabel];
    [tintCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tintCommentLabel.superview).with.offset(13);
        make.bottom.equalTo(tintCommentLabel.superview).with.offset(0);
    }];
    if ([self.viewModel.likeUserAvatars count] == 0) {
        return likesCell;
    }
    //有点赞头像的样式
    UIImageView *likeLeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall_like_leader"]];
    UILabel *likeCountLabel = [[UILabel alloc] init];
    
    [likeCountLabel setFont:[UIFont systemFontOfSize:12]];
    [likesCell.contentView addSubview:likeLeaderView];
    [likesCell.contentView addSubview:likeCountLabel];
    [likeLeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(likeLeaderView.superview).with.offset(13);
        make.top.equalTo(likeLeaderView.superview).with.offset(6);
    }];
    LKAvatarsView *avatarsView = [[LKAvatarsView alloc] init];
    [likesCell.contentView addSubview:avatarsView];
    [avatarsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeLeaderView.mas_right).with.offset(7);
        make.centerY.equalTo(likeLeaderView.mas_centerY);
        make.height.equalTo(@(24));
    }];
    [likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeLeaderView.mas_centerY);
        make.left.equalTo(avatarsView.mas_right).with.offset(7);
    }];
    @weakify(self);
    [RACObserve(self.viewModel, likeCount) subscribeNext:^(NSNumber *likeCount) {
        @strongify(self);
        if ([likeCount integerValue]<4) {
            likeCountLabel.text = [NSString stringWithFormat:@"%@ 人觉得很赞",likeCount];
        }else {
            likeCountLabel.text = [NSString stringWithFormat:@"等 %@ 人觉得很赞",likeCount];
        }
        avatarsView.avatarURLs = self.viewModel.likeUserAvatars;
    }];

    
    likesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return likesCell;
}



#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *commentNib = [UINib nibWithNibName:@"LKCommentCell" bundle:nil];
        [self.tableView registerNib:commentNib forCellReuseIdentifier:LKCommentCell.lk_identifier];
        
        UINib *commentMosaicNib = [UINib nibWithNibName:@"LKCommentMosaicCell" bundle:nil];
        [self.tableView registerNib:commentMosaicNib forCellReuseIdentifier:LKCommentMosaicCell.lk_identifier];
        
        UINib *anonymousPostDetailNib = [UINib nibWithNibName:@"LKAnonymousPostDetailCell" bundle:nil];
        [self.tableView registerNib:anonymousPostDetailNib forCellReuseIdentifier:LKAnonymousPostDetailCell.lk_identifier];
        
        UINib *postDetailCellNib = [UINib nibWithNibName:@"LKPostDetailCell" bundle:nil];
        [self.tableView registerNib:postDetailCellNib forCellReuseIdentifier:LKPostDetailCell.lk_identifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.commentListViewModel.networkingRAC.requestNextPageCommand];
        [footer setTitle:@"没有更多评论了~" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        footer.stateLabel.textColor = LKColorGray;
        footer.triggerAutomaticallyRefreshPercent = 0;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (LKCommentListViewModel *)commentListViewModel {
    if (_commentListViewModel == nil) {
        _commentListViewModel = [[LKCommentListViewModel alloc] initWithConfessionId:self.viewModel.postId];
    }
    return _commentListViewModel;
}

- (LKPostAPIManager *)updateAPIManager {
    if (_updateAPIManager == nil) {
        if (self.viewModel.relation == LKPostReleationAuthor) {
            _updateAPIManager = [LKPostAPIManager apiManagerByType:LKPostAPIManagerTypeDelete];
        }
        if (self.viewModel.relation == LKPostReleationTarget) {
            _updateAPIManager = [LKPostAPIManager apiManagerByType:LKPostAPIManagerTypeAccept];
        }
        _updateAPIManager.delegate = self;
        _updateAPIManager.dataSource = self;
    }
    return _updateAPIManager;
}

- (NSArray *)commentAPIManager {
    if (_commentAPIManager == nil) {
        NSMutableArray<LKCommentAPIManager *> *tempDic = [[NSMutableArray alloc] init];
        
        tempDic[CommentAPIManagerTypeSubmit] = [LKCommentAPIManager apiManagerByType:CommentAPIManagerTypeSubmit];
        tempDic[CommentAPIManagerTypeSubmit].delegate = self;
        tempDic[CommentAPIManagerTypeSubmit].dataSource = self;
        
        tempDic[CommentAPIManagerTypeDelete] = [LKCommentAPIManager apiManagerByType:CommentAPIManagerTypeDelete];
        tempDic[CommentAPIManagerTypeDelete].delegate = self;
        tempDic[CommentAPIManagerTypeDelete].dataSource = self;
        
        
        _commentAPIManager = [tempDic copy];
    }
    return _commentAPIManager;
}

- (LKPostAPIManager *)referAPIManager {
    if (_referAPIManager == nil) {
        _referAPIManager = [LKPostAPIManager apiManagerByType:LKPostAPIManagerTypeRefer];
        _referAPIManager.delegate = self;
        _referAPIManager.dataSource = self;
    }
    return _referAPIManager;
}

- (UIView *)emptyFooterView {
    UIView *emptyView = [UIView new];
    emptyView.frame = CGRectMake(0, 0, MainViewSize.width, MainViewSize.width * 9 / 16);//宽:高=16:9
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_preview"]];
    UILabel *emptyTintLabel = [[UILabel alloc] init];
    emptyTintLabel.text = @"还没有评论哦，快来抢占沙发吧！";
    emptyTintLabel.font = [UIFont boldSystemFontOfSize:14];
    emptyTintLabel.textColor = [UIColor grayColor];
    [emptyView addSubview:emptyImageView];
    [emptyView addSubview:emptyTintLabel];
    emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(81, 95));
    }];
    [emptyTintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).with.offset(5);
    }];
    return emptyView;
}



- (LKInputToolBar *)inputToolBar {
    if(_inputToolBar == nil) {
        _inputToolBar = [LKInputToolBar inputToolBar];
        _inputToolBar.frame = self.view.frame;
        _inputToolBar.resident = YES;
        _inputToolBar.delegate = self;
        _inputToolBar.maxLength = 300;
    }
    return _inputToolBar;
}

- (ConfessionCommentRelation)makeCommentRelationForCommentViewModel:(LKCommentViewModel *)viewModel {
    if ([viewModel.user.userId isEqualToString:[User sharedInstance].userId]) {
        return ConfessionCommentRelationAuthor;
    }
    if ([viewModel.user.userId isEqualToString:@"0"] && self.viewModel.relation == LKPostReleationAuthor) {
        return ConfessionCommentRelationAuthor;
    }
    return ConfessionCommentRelationDefault;
}


- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = [LKEmptyManager defaultEmptyManagerWithScrollView:self.tableView style:LKEmptyManagerStyleNoData];
        _emptyManager.delegate = self;
    }
    return _emptyManager;
}

- (void)dealloc {
    NSLog(@"Detail dealloc");
}
@end
