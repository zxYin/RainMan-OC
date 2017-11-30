//
//  HomeViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/29.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "HomeViewController.h"
#import "UMessage.h"
#import "ViewsConfig.h"

// TableView相关
#import "YLTableViewManager.h"
#import "YLTableViewManager+ReactiveExtension.h"

#import "HomePageHeaderView.h"

#import "CourseAdCell.h"
#import "ToolsViewCell.h"

#import "AppMediator+LKNewsModule.h"
#import "AppMediator+LKLoginModule.h"
#import "AppMediator+LKFlowModule.h"
#import "AppMediator+LKCourseModule.h"
#import "AppMediator+LKLibraryModule.h"
#import "AppMediator+LKActivityModule.h"

#import "ToolsSection.h"

#import "DateTools.h"
#import "TBActionSheet.h"

#import "CourseCountdownView.h"

#import "LKPermissionManager.h"

#import "LKCASWebBrowser.h"
#import "LocalNotificationManager.h"
#import "YLBadge.h"
#import "LKMessageManager.h"

@interface HomeViewController ()<YLTableViewDelegate,UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) YLTableView *tableView;
@property (nonatomic, strong) UIView *colorBackgroundView;

@property (nonatomic, strong) YLTableViewSection *newsSection;
@property (nonatomic, strong) YLTableViewSection *toolsSection;
@property (nonatomic, strong) YLTableViewSection *courseAdSection;
@property (nonatomic, strong) YLTableViewSection *librarySection;
@property (nonatomic, strong) YLTableViewSection *lectureSection;
@property (nonatomic, strong) YLTableViewSection *scheduleSection;

@property (nonatomic, strong) CourseCountdownView *pullView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [UMessage addCardMessageWithLabel:@"home"];
    
    [self.view addSubview:self.colorBackgroundView];
    [self.view addSubview:self.pullView];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self.tabBarController.tabBarItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeShake];
    
#ifdef DEBUG
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"测试" style:UIBarButtonItemStylePlain handler:^(id sender) {
//        LKCASWebBrowser *vc = [LKCASWebBrowser webBrowserWithURL:[NSURL URLWithString:@"http://card.xjtu.edu.cn:8070/SynCard/Manage/Transfer"] title:@"测试"];
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }];
    
#endif
    
    // setup sections
    [self.tableView registerSection:self.courseAdSection];
    [self.tableView registerSection:self.newsSection];
    [self.tableView registerSection:self.scheduleSection];
    [self.tableView registerSection:self.toolsSection];
    [self.tableView registerSection:self.librarySection];
    [self.tableView registerSection:self.lectureSection];
    
    
    @weakify(self);
    RAC(self.navigationItem, title) =
    [[RACSignal combineLatest:@[
                               RACObserve(self.courseAdSection, loaded),
                               RACObserve(self.newsSection, loaded),
                               RACObserve(self.toolsSection, loaded),
                               RACObserve(self.librarySection, loaded),
                               RACObserve(self.lectureSection, loaded),
                               RACObserve(self.scheduleSection, loaded),
                               ] reduce:^id{
                                   @strongify(self);
                                   return
                                   @(self.courseAdSection.isLoaded
                                   && self.newsSection.isLoaded
                                   && self.toolsSection.isLoaded
                                   && self.lectureSection.isLoaded
                                   && self.scheduleSection.isLoaded);
                               }] map:^id(id value) {
                                   return [value boolValue]?@"西交Link":@"西交Link（收取中...）";
                               }];
    
    [RACObserve([LKMessageManager sharedInstance], unreadMessageCount) subscribeNext:^(NSNumber *count) {
        NSInteger unreadMessageCount = [count integerValue];
        NSArray *items = [[AppContext sharedInstance] currentTabBarController].tabBar.items;
        UITabBarItem *discoverItem = items[LKTabBarItemDiscover];
        if (unreadMessageCount <= 0) {
            [discoverItem yl_clearBadge];
        } else {
            [discoverItem yl_showBadgeNumber:unreadMessageCount];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    // 这里会要求所有的Section进行网络刷新
    // 但是具体到某个Section会不会发起网络请求，由Section自己决定
    [self.courseAdSection setNeedUpdate];
    [self.newsSection setNeedUpdate];
    [self.toolsSection setNeedUpdate];
    [self.librarySection setNeedUpdate];
    [self.lectureSection setNeedUpdate];
    [self.scheduleSection setNeedUpdate];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pullView.frame = CGRectMake(0, 0, MainScreenSize.width, CourseCountdownViewHeight);
    
}


#pragma mark - YLTableViewDelegate
- (void)yl_tableView:(YLTableView *)tableView configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath section:(YLTableViewSection *)section {
    if(self.lk_forceTouchAvailable) {
        // 注册3D Touch
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
}

- (void)yl_tableView:(YLTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath section:(YLTableViewSection *)section withObject:(UIViewController *)obj {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([obj isKindOfClass:[UIViewController class]]) {
        obj.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

- (UIView *)yl_tableView:(YLTableView *)tableView viewForHeaderInSection:(YLTableViewSection *)section {
    CGRect frame = CGRectMake(0, 0, MainScreenSize.width, HomePageHeaderViewHeight);
    HomePageHeaderView *header = [[HomePageHeaderView alloc] initWithFrame:frame];
    header.title = section.title;
    
    @weakify(self);
    if([section.title isEqualToString:self.courseAdSection.title]) {
        header.lineSpaceToBottom = 10;
    } else if([section.title isEqualToString:self.newsSection.title]) {
        header.isShowMore = YES;
        [header bk_whenTapped:^{
            @strongify(self);
            UIViewController *vc = [[AppMediator sharedInstance] LKNews_newsListViewController];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    } else if([section.title isEqualToString:self.librarySection.title]) {
        header.isShowMore = YES;
        [header bk_whenTapped:^{
            @strongify(self);
            [[AppMediator sharedInstance] LKLibrary_libraryViewController:^(UIViewController *libraryViewController) {
                libraryViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:libraryViewController animated:YES];
            }];
        }];
    } else if([section.title isEqualToString:self.lectureSection.title]) {
        header.isShowMore = YES;
        [header bk_whenTapped:^{
            @strongify(self);
            UIViewController *vc = [[AppMediator sharedInstance] LKActivity_lectureListViewController];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    } else if([section.title isEqualToString:self.scheduleSection.title]) {
        header.isShowMore = YES;
        [header bk_whenTapped:^{
            @strongify(self);
            [[AppMediator sharedInstance] LKCourse_scheduleViewController:^(UIViewController *scheduleViewController) {
                scheduleViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scheduleViewController animated:YES];
            }];
        }];
    }
    return header;
}

- (CGFloat)yl_tableView:(YLTableView *)tableView heightForHeaderInSection:(YLTableViewSection *)section {
    if([section.title isEqualToString:self.courseAdSection.title]) {
        return HomePageHeaderViewHeight + 10;
    }
    return HomePageHeaderViewHeight;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        CGFloat absOffset = fabs(offset);
        CGRect frame = self.colorBackgroundView.frame;
        frame.size.height = absOffset;
        self.colorBackgroundView.frame = frame;
    }
    
    if (offset > 0) {
        [self.navigationController.navigationBar lt_setBackgroundColor:LKColorLightBlue];
    } else {
        // 35 173 229    0x23ade5
        // -> 231 37 32  0xe72520 上课
        // 55 183 180 下课

        CGFloat range = 60;
        CGFloat alpha = MIN(1,(range - offset) / range -1);
        UIColor *color = nil;
        if (self.pullView.viewModel.isClassTime) {
            color = [UIColor colorWithRed:(35 + alpha * (231-35)) /255.0
                                    green:(173 + alpha * (37-137)) /255.0
                                     blue:(229 + alpha * (32-229)) /255.0 alpha:1.0];
        } else {
            color = [UIColor colorWithRed:(35 + alpha * (55-35)) /255.0
                                    green:(173 + alpha * (183-137)) /255.0
                                     blue:(229 + alpha * (180-229)) /255.0 alpha:1.0];
        }
        [self.navigationController.navigationBar lt_setBackgroundColor:color];
        self.colorBackgroundView.backgroundColor = color;
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    UIViewController *vc = [self.tableView previewingForIndexPath:indexPath];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}


#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[YLTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.yl_delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (YLTableViewSection *)newsSection {
    if (_newsSection == nil) {
        _newsSection = [[AppMediator sharedInstance] LKNews_newsSection];
    }
    return _newsSection;
}

- (YLTableViewSection *)toolsSection {
    if (_toolsSection == nil) {
        _toolsSection = [[ToolsSection alloc] init];
    }
    return _toolsSection;
}

- (YLTableViewSection *)courseAdSection {
    if(_courseAdSection == nil) {
        _courseAdSection = [[AppMediator sharedInstance] LKCourse_courseAdSection];
    }
    return _courseAdSection;
}

- (YLTableViewSection *)librarySection {
    if (_librarySection == nil) {
        _librarySection = [[AppMediator sharedInstance] LKLibrary_librarySection];
    }
    return _librarySection;
}

- (YLTableViewSection *)lectureSection {
    if (_lectureSection == nil) {
        _lectureSection = [[AppMediator sharedInstance] LKActivity_lectureSection];
    }
    return _lectureSection;
}

- (YLTableViewSection *)scheduleSection {
    if (_scheduleSection == nil) {
        _scheduleSection = [[AppMediator sharedInstance] LKCourse_scheduleSection];
    }
    return _scheduleSection;
}


- (UIView *)colorBackgroundView {
    if (_colorBackgroundView == nil) {
        _colorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, 0)];
        _colorBackgroundView.backgroundColor = LKColorLightBlue;
    }
    return _colorBackgroundView;
}

- (CourseCountdownView *)pullView {
    if (_pullView == nil) {
        _pullView = [CourseCountdownView courseCountdownView];
    }
    return _pullView;
}
@end
