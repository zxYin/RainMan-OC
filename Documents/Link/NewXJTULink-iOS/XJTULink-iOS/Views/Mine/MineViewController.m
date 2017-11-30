//
//  MineViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MineViewController.h"
#import "ViewsConfig.h"
#import "MineItemCell.h"
#import "MineViewModel.h"
#import "MeHeaderView.h"
#import "User.h"
#import "AppMediator+LKCourseModule.h"
#import "AppMediator+LKLibraryModule.h"
#import "AppMediator+LKCardModule.h"
#import "AppMediator+LKSettingModule.h"
#import "APpMediator+LKClassroomModule.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) MeHeaderView *headerView;
@property (nonatomic, strong) MineViewModel *viewModel;
@end


@implementation MineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.view addSubview:self.tableView];
    
//    self.headerView.frame = CGRectMake(0, 0, MainScreenSize.width, MeHeaderViewHeight);
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.tableHeaderViewHe
    
    [self.view addSubview:self.headerView];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(MeHeaderViewHeight, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    RAC(self.headerView.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
    RAC(self.headerView.nameLabel, text) = RACObserve(self.viewModel, name);
    
    @weakify(self);
    [RACObserve(self.viewModel, avatarURL) subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView.headImageView sd_setImageWithURL:x];
        [self.headerView.backgroundImageView sd_setImageWithURL:x];
    }];
    
    
    [self.headerView.headImageView bk_whenTapped:^{
        [[AppMediator sharedInstance] LKSetting_profileViewController:^(UIViewController *vc) {
            @strongify(self);
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    
    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    navigationBar.shadowImage = [[UIImage alloc] init];
//    navigationBar.translucent = YES;
//    [navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    UINib *nib = [UINib nibWithNibName:@"MineItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:MineItemCell.lk_identifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, MainScreenSize.width, MeHeaderViewHeight);
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.mineItemViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:MineItemCell.lk_identifier
                                                         forIndexPath:indexPath];
    MineItemViewModel *viewModel = self.viewModel.mineItemViewModels[indexPath.row];
    RAC(cell.titleLabel, text) = [RACObserve(viewModel, title) takeUntil:cell.rac_prepareForReuseSignal];
    
    if(viewModel.imageURL != nil) {
        [cell.iconImageView sd_setImageWithURL:viewModel.imageURL
                              placeholderImage:viewModel.image];
    } else {
        cell.iconImageView.image = viewModel.image;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MineItemCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineItemViewModel *viewModel = self.viewModel.mineItemViewModels[indexPath.row];
    UIViewController *vc = nil;
    switch (viewModel.tag) {
        case kMineItemTranscripts: {
            [[AppMediator sharedInstance] LKCourse_transcriptsViewController:^(UIViewController *transcriptsViewController) {
                transcriptsViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:transcriptsViewController animated:YES];
            }];
            break;
        }
        case kMineItemIdleClassroom: {
            vc = [[AppMediator sharedInstance] LKClassroom_classroomViewController];
            break;
        }
        case kMineItemLibrary: {
            [[AppMediator sharedInstance] LKLibrary_libraryViewController:^(UIViewController *libraryViewController) {
                libraryViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:libraryViewController animated:YES];
            }];
            
            break;
        }
        case kMineItemFavorites: {
            [AppContext showProgressFailHUDWithMessage:@"暂未开启"];
            break;
        }
        case kMineItemTransfer: {
            [[AppMediator sharedInstance] LKCard_transferViewController:^(UIViewController *transferViewController) {
                transferViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:transferViewController animated:YES];
            }];
            break;
        }
        case kMineItemTeachingEvaluation: {
            [[AppMediator sharedInstance] LKCourse_teachingEvaluationViewController:^(UIViewController *teachingEvaluationViewController) {
                teachingEvaluationViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:teachingEvaluationViewController animated:YES];
            }];
            break;
        }
//        case kMineItemExam: {
//            [[AppMediator sharedInstance] LKCourse_scheduleViewController:^(UIViewController *scheduleViewController) {
//                scheduleViewController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:scheduleViewController animated:YES];
//            }];
//            break;
//        }
    
        case kMineItemSetting: {
            vc =  [[AppMediator sharedInstance] LKSetting_settingViewController];
            break;
        }
        default:{
            if (viewModel.webURL != nil) {
                
            }
            break;
        }
    }
    
    if(vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    NSLog(@"offset = %f",offset);
    
    if (offset <= - MeHeaderViewHeight) {
        CGRect frame = self.headerView.frame;
        frame.origin.y = 0;
        frame.size.height = fabs(offset);
        self.headerView.frame = frame;
    } else {
        CGRect frame = self.headerView.frame;
        frame.origin.y = -1 * (MeHeaderViewHeight + offset);
        frame.size.height = MeHeaderViewHeight;
        self.headerView.frame = frame;
    }
    
    
    CGFloat threshold = -225;
    if(offset > threshold) {
        UIColor *color = [LKColorLightBlue colorWithAlphaComponent:(offset-threshold)/100.0];
        [self.navigationController.navigationBar lt_setBackgroundColor:color];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (MineViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MineViewModel alloc] init];
    }
    return _viewModel;
}

- (MeHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [MeHeaderView meHeaderView];
    }
    return _headerView;
}
@end
