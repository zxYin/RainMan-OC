//
//  DiscoverViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DiscoverViewController.h"

#import "ViewsConfig.h"
#import "YLTableViewManager.h"
#import "YLTableViewManager+ReactiveExtension.h"
#import "ColorMacros.h"
#import "LKWebBrowser.h"

#import "YLGridTableViewCell.h"
#import "DiscoverAdCell.h"
#import "LKSearchBar.h"
#import "ClubViewController.h"
#import "SpecialColumnCell.h"
#import "ClubItemCell.h"
#import "DiscoverSectionHeader.h"
#import "FeedViewModel.h"

#import "ClubListViewModel.h"
#import "ClubListViewController.h"
#import "LKSearchViewController.h"

#import "LocalNotificationManager.h"
#import "UIImage+LKExpansion.h"
#import "LKSharePanel.h"

#import "DiscoverHeadlineCell.h"
#import "LKCommunityEntryCell.h"
#import "CommunityViewContoller.h"

#import "LKMessageViewController.h"
#import "AcademyManager.h"

#import "LKMessageManager.h"
#import "YLBadge.h"


static NSString * const kDiscoverAdCell = @"轮播大屏幕";
static NSString * const kSpecialColumnCell = @"专栏";
static NSString * const kConfessionEntryCell = @"表白墙";
static NSString * const kClubClassifyCell = @"社团分类";
static NSString * const kHotestCell = @"24小时最热";

@interface DiscoverViewController()<YLTableViewManagerDelegate,YLGridTableViewCellDeleagte,LKSearchBarDelegate,SpecialColumnDelegate,ClubItemCellDelegate,LKEmptyManagerDelegate,DiscoverHeadlineCellDelegate>
@property (nonatomic, copy) LKSearchBar *searchBar;
@property (nonatomic, strong) YLTableViewManager *tableViewManager;
@property (nonatomic, strong) FeedViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *eggLabel;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.view.backgroundColor = LKColorLightGray;

    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.eggLabel];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.navigationController.view addSubview:self.searchBar];
    

    UIBarButtonItem *messageItem =
    [[UIBarButtonItem alloc]
     bk_initWithImage:[UIImage imageNamed:@"nav_message_icon"]
     style:UIBarButtonItemStyleDone handler:^(id sender) {
         [LKMessageManager sharedInstance].unreadMessageCount = 0;
         LKMessageViewController *vc = [[LKMessageViewController alloc] init];
         vc.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    [self setupSections];
    
    [self setupRAC];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [[AcademyManager sharedInstance] setNeedsUpdate];
    
    
    [RACObserve([LKMessageManager sharedInstance], unreadMessageCount) subscribeNext:^(NSNumber *count) {
        NSInteger unreadMessageCount = [count integerValue];
        if (unreadMessageCount <= 0) {
            [messageItem yl_clearBadge];
        } else {
            messageItem.yl_badge.alignment = YLBadgeAlignmentBottomRight;
            [messageItem yl_showBadgeNumber:unreadMessageCount];
        }
        
    }];
}

- (void)setupRAC {
    @weakify(self);
    
    [[RACObserve(self.viewModel, needReload) filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        self.searchBar.placeholder = self.viewModel.searchText;
        [self setupSections];
        [self.tableView reloadData];
        self.viewModel.needReload = NO;
    }];
    
    
//    RAC(self.searchBar, placeholder) = RACObserve(self.viewModel, searchText);
//    [self.tableViewManager binding:RACObserve(self.viewModel, headlineModels) forKey:kDiscoverAdCell];
//    [self.tableViewManager binding:RACObserve(self.viewModel, specialColumnModel) forKey:kSpecialColumnCell];
//    [self.tableViewManager binding:RACObserve(self.viewModel, hottestClubViewModel) forKey:kHotestCell];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         self.searchBar.hidden = YES;
         [self.tableViewManager clearSections];
         [self.emptyManager reloadEmptyDataSet];
         [RKDropdownAlert title:@"网络错误"];
     }];
    
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel.networkingRAC.requestCommand tryExecuteIntervalLongerThan:60];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [CommunityContext setupCurrentContext:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    CGFloat threshold = DiscoverAdCellHeight - [self realNavigationBarHeight];
    return self.tableView.contentOffset.y > threshold + 20 ? UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (void)setupSections {
    [self.tableViewManager clearSections];
    
    @weakify(self);
    [self.tableViewManager
     registerSectionWithKey:kDiscoverAdCell
     class:[DiscoverHeadlineCell class]
     cell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, DiscoverHeadlineCell *cell) {
         @strongify(self);
         cell.viewModels = self.viewModel.headlineModels;
         cell.delegate = self;
         return cell;
     }
     height:DiscoverHeadlineCellHeight
     didClick:nil];
    
    
    
    [self.tableViewManager
     registerSectionWithKey:kSpecialColumnCell
     class:[SpecialColumnCell class]
     header:^UIView *(UITableView *tableView) {
         return [DiscoverSectionHeader discoverSectionHeaderWithTitle:self.viewModel.specialColumnModel.title];
     } footer:nil
     cell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, SpecialColumnCell *cell) {
         @strongify(self);
         cell.viewModel = self.viewModel.specialColumnModel;
         cell.delegate = self;
         return cell;
     }
     height:SpecialColumnCellHeight
     didClick:nil];
    
    
    [self.viewModel.communityContexts enumerateObjectsUsingBlock:^(CommunityContext * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        CommunityContext *context = self.viewModel.communityContexts[idx];
        NSString *key = [NSString stringWithFormat:@"%@_%td",kConfessionEntryCell,idx];
        [self.tableViewManager registerSectionWithKey:key nib:@"LKCommunityEntryCell" cell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, LKCommunityEntryCell *cell) {
            [cell.entryImageView sd_setImageWithURL:[NSURL URLWithString:context.image]];
            return cell;
        } height:LKCommunityEntryCellHeight didClick:^(UITableView *tableView, NSIndexPath *indexPath, id cell) {
            CommunityViewContoller *vc = [[CommunityViewContoller alloc] initWithContext:context];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    [self.tableViewManager
     registerSectionWithKey:kClubClassifyCell
     class:[YLGridTableViewCell class]
     cell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, YLGridTableViewCell *cell) {
         @strongify(self);
         cell.items = [self.viewModel.clubTypes bk_map:^id(NSDictionary *type) {
             return @{
                      kYLGridItemTitle:type[kClubTypeKeyTitle] ,
                      kYLGridItemImage:[type[kClubTypeKeyImage] imageWithTintColor:[UIColor flatCoffeeDarkColor]],
                      };
         }];
         cell.columnCount = 4;
         cell.delegate = self;
         return cell;
     }
     height:ceil([self.viewModel.clubTypes count] / 4.0) * 80
     didClick:nil];
    
    
    [self.tableViewManager
     registerSectionWithKey:kHotestCell
     nib:@"ClubItemCell"
     header:^UIView *(UITableView *tableView) {
         return [DiscoverSectionHeader discoverSectionHeaderWithTitle:kHotestCell];
     } footer:nil
     cell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, ClubItemCell *cell) {
         @strongify(self);
         cell.viewModel = self.viewModel.hottestClubViewModel;
         cell.delegate = self;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
     } height:ClubItemCellHeight-1 //减1是为了去除末端的横线
     didClick:^(UITableView *tableView, NSIndexPath *indexPath, ClubItemCell *cell) {
         UIViewController *vc;
         if (cell.viewModel.showType == kPageShowTypeWeb) {
             vc = [LKWebBrowser webBrowserWithURL:cell.viewModel.webURL title:cell.viewModel.name];
         } else {
             vc = [[ClubViewController alloc] initWithViewModel:cell.viewModel];
         }
         [self.navigationController pushViewController:vc animated:YES];
     }];
}



#pragma mark - delegate
- (BOOL)searchBarShouldBeginEditing:(LKSearchBar *)searchBar {
    LKSearchViewController *vc = [[LKSearchViewController alloc] initWithPlaceholder:self.viewModel.searchText];
    [self.navigationController pushViewController:vc animated:NO];
    return NO;
}

- (void)gridItemDidClickAtIndex:(NSInteger)index {
    ClubListViewModel *viewModel = [[ClubListViewModel alloc] initWithInitialTypeId:self.viewModel.clubTypes[index][kClubTypeKeyId]];
    UIViewController *vc = [[ClubListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)discoverAdCell:(DiscoverAdCell *)cell didTapViewAtIndex:(NSInteger)index {

    HeadlineModel *model = self.viewModel.headlineModels[index];
    if(model == nil) return;
    UIViewController *vc;
    if(model.type == kHeadlineTypeClub) {
        ClubViewModel *viewModel = [[ClubViewModel alloc] initWithClubId:model.clubId];
        vc = [[ClubViewController alloc] initWithViewModel:viewModel];
    } else {
        vc = [[LKWebBrowser alloc] initWithURL:model.url title:@"Link头条"];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)discoverHeadlineCell:(DiscoverHeadlineCell *)cell didTapViewAtIndex:(NSInteger)index {
    HeadlineModel *model = self.viewModel.headlineModels[index];
    if(model == nil) return;
    UIViewController *vc;
    if(model.type == kHeadlineTypeClub) {
        ClubViewModel *viewModel = [[ClubViewModel alloc] initWithClubId:model.clubId];
        vc = [[ClubViewController alloc] initWithViewModel:viewModel];
    } else {
        vc = [[LKWebBrowser alloc] initWithURL:model.url title:@"Link头条"];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (NSInteger)discoverAdCellintervalOfCarousel {
//    return self.isVisible?4:0;
//}

- (void)specialColumn:(SpecialColumnCell *)cell didTapIndex:(NSInteger)index {
    SingleURLModel *model = self.viewModel.specialColumnModel.items[index];
    if (model == nil) return;
    LKWebBrowser *vc = [[LKWebBrowser alloc] initWithURL:model.url title:model.title];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clubItemCell:(ClubItemCell *)cell shareButtonDidClick:(id)sender {
    LKShareModel *model = cell.viewModel.shareModel;
    model.image = cell.clubImageView.image;
    LKSharePanel *panel = [[LKSharePanel alloc] initWithShareModel:model];
    panel.title = [NSString stringWithFormat:@"邀请好友加入%@吧！",cell.viewModel.name];
    [panel show];
}

- (void)emptyManager:(LKEmptyManager *)manager didTapView:(UIView *)view {
    [self setupSections];
    [self.tableView reloadData];
    self.searchBar.hidden = NO;
    [self.viewModel.networkingRAC.requestCommand execute:nil];
}

#pragma mark - YLTableViewManagerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        self.searchBar.alpha = 1 - fabs(offset)/ 60.0;
    } else {
        self.searchBar.alpha = 1;
    }
    
    CGFloat threshold = DiscoverAdCellHeight - [self realNavigationBarHeight];
    if(offset > threshold) {
        UIColor *color = [LKColorLightBlue colorWithAlphaComponent:(offset-threshold)/100.0];
        [self.navigationController.navigationBar lt_setBackgroundColor:color];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self configEgg:offset];
}


- (void) configEgg:(CGFloat)offset {
    static CGFloat lastOffset = 0;
    if(offset >= 0) {
        self.backgroundImageView.hidden = YES;
        self.eggLabel.hidden = YES;
    } else {
        self.backgroundImageView.hidden = NO;
        self.eggLabel.hidden = NO;
    }
    
    NSInteger up = 1;
    NSInteger down = -1;
    NSInteger direction = lastOffset<offset ?up:down;
    if(offset > -300) {
        if (direction == up) {
             self.eggLabel.text = @"其实不能拉的。";
        } else {
            self.eggLabel.text = @"居然没东西？";
        }
    } else if(offset > 490) {
        if (direction == up) {
            self.eggLabel.text = @"就知道你不拉了！";
        } else {
            self.eggLabel.text = @"没用的，别拉了";
        }
    } else if(offset > - 520) {
        self.eggLabel.text = @"别逼我，你再拉要出事了！！";
        
    } else if(offset > - 550) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [LocalNotificationManager registerLocalNotificationWithMessage:@"😆既然你那么有时间，给个好评吧！" atDate:[NSDate date] url:nil forKey:nil];
        });
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStorePath]];
    }
    lastOffset = offset;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSectionKey:(NSString *)key {
    if (
        [key isEqualToString:kSpecialColumnCell]
        || [key isEqualToString:kHotestCell]
        ) {
        return DiscoverSectionHeaderHeight;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSectionKey:(NSString *)key {
    if ([key isEqualToString:kDiscoverAdCell]
        ) {
        return 0.01;
    }
    return 15;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (FeedViewModel *)viewModel {
    if(_viewModel == nil) {
        _viewModel = [[FeedViewModel alloc] init];
    }
    return _viewModel;
}

- (YLTableViewManager *)tableViewManager {
    if (_tableViewManager == nil) {
        _tableViewManager = [[YLTableViewManager alloc] initWithTableView:self.tableView];
        _tableViewManager.delegate = self;
    }
    return _tableViewManager;
}

- (LKSearchBar *)searchBar {
    if (_searchBar == nil) {
        CGRect frame = self.navigationController.navigationBar.frame;
        frame.size.width -= 40;
        frame.origin.y = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + 2;
        _searchBar = [[LKSearchBar alloc] initWithFrame:frame];
        _searchBar.edgeInsets = UIEdgeInsetsMake(5, 10, 10, 10);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (CGFloat)realNavigationBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
            + CGRectGetHeight(self.navigationController.navigationBar.frame);
}

- (UIImageView *)backgroundImageView {
    if(_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_preview"]];
        _backgroundImageView.center = CGPointMake(MainScreenSize.width/2, _backgroundImageView.frame.size.height/2 + 10);
    }
    return _backgroundImageView;
}

- (UILabel *)eggLabel {
    if (_eggLabel == nil) {
        _eggLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backgroundImageView.frame) + 50, MainScreenSize.width, 20)];
        _eggLabel.textAlignment = NSTextAlignmentCenter;
        _eggLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }
    return _eggLabel;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
        _emptyManager.delegate = self;
    }
    return _emptyManager;
}

@end

