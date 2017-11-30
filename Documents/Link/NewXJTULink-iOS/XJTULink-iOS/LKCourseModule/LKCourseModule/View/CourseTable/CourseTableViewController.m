//
//  CourseTableViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/18.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseTableViewController.h"
#import "NSDate+LKTools.h"
#import "CourseTableCell.h"
#import "DayHeaderView.h"
#import "SideHeaderView.h"
#import "Macros.h"
#import "ViewsConfig.h"
#import "CourseTableViewModel.h"
#import "Foundation+LKCourse.h"
#import "WeekCourseTableLayout.h"
#import "YPMenuController.h"
#import "WeekHeaderView.h"
#import "TBActionSheet.h"
#import "CourseDetailViewController.h"
#import "CourseEditViewController.h"
#import "LKShareViewController.h"
#import "ScheduleViewController.h"
#import "ScheduleEditViewController.h"
#import "ScheduleEditViewModel.h"
#import "RTRootNavigationController.h"
#import "ScheduleManager.h"
#import "ScheduleItemViewModel.h"

@interface CourseTableViewController ()<WeekCourseTableLayoutDataSource,UIViewControllerPreviewingDelegate>
@property (strong,nonatomic) YPMenuController *menuController;

@property (nonatomic, strong) CourseTableViewModel *viewModel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSMutableSet *usedColorSet;
@property (nonatomic, strong) NSMutableDictionary *courseColorDict;
@end

@implementation CourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self setupRAC];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.menuController.view];
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"考试" style:UIBarButtonItemStylePlain handler:^(id sender) {
        ScheduleViewController *vc = [[ScheduleViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        @strongify(self);
        TBActionSheet *actionSheet = [[TBActionSheet alloc] init];

        [actionSheet addButtonWithTitle:@"同步课表" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            UIBarButtonItem *oldItem = self.navigationItem.rightBarButtonItem;
            UIActivityIndicatorView *activityIndicatorView =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            [self.viewModel.networkingRAC.executionSignal subscribeNext:^(id x) {
                self.navigationItem.rightBarButtonItem = oldItem;
                [AppContext showProgressFinishHUDWithMessage:@"同步课表成功"];
            }];
            
            [self.viewModel.networkingRAC.requestErrorSignal subscribeNext:^(YLResponseError *error) {
                self.navigationItem.rightBarButtonItem = oldItem;
                [AppContext showProgressFailHUDWithMessage:@"同步课表失败"];
            }];
            [[self.viewModel.networkingRAC requestCommand] execute:nil];
        }];
        
        [actionSheet addButtonWithTitle:@"添加课程" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            CourseEditViewModel *viewModel = [[CourseEditViewModel alloc] initWithModel:nil];
            CourseEditViewController *vc = [[CourseEditViewController alloc] initWithViewModel:viewModel];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [actionSheet addButtonWithTitle:@"添加考试" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            
            ScheduleEditViewModel *viewModel = [[ScheduleEditViewModel alloc] initWithType:ScheduleEditViewModelTypeAdd];
            ScheduleEditViewController *vc = [[ScheduleEditViewController alloc] initWithViewModel:viewModel];
            vc.hidesBottomBarWhenPushed = YES;
            
            
            @weakify(self);
            [self.rt_navigationController pushViewController:vc animated:YES complete:^(BOOL finished) {
                @strongify(self);
                ScheduleViewController *svc = [[ScheduleViewController alloc] init];
                svc.hidesBottomBarWhenPushed = YES;
                [self.rt_navigationController insertViewController:svc atIndex:self.rt_navigationController.viewControllers.count - 1];
                
            }];
            
        }];

        
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        
        [actionSheet show];

    }];
    
//    WeekHeaderView *header = [WeekHeaderView weekHeaderView];
//    [self.view addSubview:header];
////    [header ma]
//    [header mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view);
//        make.left.mas_equalTo(self.view);
//        make.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(50);
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel resetWeek];
    [self.menuController selectIndex:(MAX(self.viewModel.week, 1) - 1)];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidTakeScreenshot:(NSNotification *)notification {
    NSLog(@"检测到截屏");
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *courseTableImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    LKShareMarkView *markView = [LKShareMarkView shareMarkView];
    markView.markLabel.text = @"来自西交Link · 课表分享";
//    [markView.markLabel sizeToFit];
//    [markView setNeedsLayout];
//    [markView setNeedsDisplay];
//    [markView setNeedsUpdateConstraints];
    [markView layoutSubviews];
    [markView updateConstraints];
    [markView updateConstraintsIfNeeded];
    [markView setNeedsUpdateConstraints];
    [markView setNeedsFocusUpdate];
    
    UIImage *markImage = [markView markImage];
    
    CGFloat width = MainScreenSize.width;
    CGFloat height = courseTableImage.size.height + markImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(offScreenSize, YES, [UIScreen mainScreen].scale);
    
    [courseTableImage drawInRect:CGRectMake(0, 0, width, courseTableImage.size.height)];
    [markImage drawInRect:CGRectMake(0, courseTableImage.size.height, width, markImage.size.height)];
    
    UIImage *sharedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    LKShareViewController *vc = [[LKShareViewController alloc] initWithImage:sharedImage];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - setup
- (void)setupCollectionView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.backgroundColor = [LKColorLightBlue colorWithAlphaComponent:0.05];
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    
    UIView *superView = self.view;
    [superView addSubview:self.backgroundImageView];
    [superView sendSubviewToBack:self.backgroundImageView];
    
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView).offset(MainScreenSize.height * 0.3);
        make.right.mas_equalTo(superView).offset(-30);
        make.left.mas_equalTo(superView).offset(30);
    }];


    
    UINib *headerViewNib = [UINib nibWithNibName:@"DayHeaderView" bundle:nil];
    [self.collectionView registerNib:headerViewNib
          forSupplementaryViewOfKind:DayHeaderViewIdentifier
                 withReuseIdentifier:DayHeaderViewIdentifier];
    
    UINib *sideHeaderViewNib = [UINib nibWithNibName:@"SideHeaderView" bundle:nil];
    [self.collectionView registerNib:sideHeaderViewNib
          forSupplementaryViewOfKind:SideHeaderViewIdentifier
                 withReuseIdentifier:SideHeaderViewIdentifier];
    
}

- (void)setupRAC {
    @weakify(self);
    [RACObserve(self.viewModel, week) subscribeNext:^(id x) {
        @strongify(self);
        NSString *title =
        [@"课程表" stringByAppendingFormat:@"（第%td周）",self.viewModel.week];
        UIButton *titleButton = [UIButton buttonWithType: UIButtonTypeSystem];
        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleButton setImage:[UIImage imageNamed:@"nav_dropdown_normal"]
                     forState:UIControlStateNormal];
        
        titleButton.imageView.contentMode =
        UIViewContentModeCenter;
        [titleButton setTitle: title forState: UIControlStateNormal];
        [titleButton sizeToFit];
        
        CGSize titleLabelSize = titleButton.titleLabel.intrinsicContentSize;
        titleButton.titleEdgeInsets =
        UIEdgeInsetsMake(0, -5, 0, 5);
        
        titleButton.imageEdgeInsets =
        UIEdgeInsetsMake(0, titleLabelSize.width + 5, 0, -5);
        
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
    }];
    
    [RACObserve(self.viewModel, courseViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];

}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseViewModel *courseViewModel = self.viewModel.courseViewModels[indexPath.item];
    CourseDetailViewModel *detailViewModel = [[CourseDetailViewModel alloc] initWithCourseViewModel:courseViewModel];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc] initWithViewModel:detailViewModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.courseViewModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseTableCell" forIndexPath:indexPath];
    
    CourseViewModel *viewModel = self.viewModel.courseViewModels[indexPath.item];
    cell.titleLabel.text = viewModel.title;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    if ([self.viewModel isExpired:viewModel]) {
        cell.titleLabel.textColor = LKColorDarkGray;
        cell.backgroundColor = LKColorGray;
        cell.alpha = 0.3;
    } else {
        cell.titleLabel.textColor = [UIColor whiteColor];
        NSString *key = viewModel.name?:@"";
        UIColor *color = [self tryFetchColorFromSetForKey:key];
        self.courseColorDict[key] = color;
        [self.usedColorSet addObject:color];
        cell.alpha = 1;
        cell.backgroundColor = [color colorWithAlphaComponent:0.8];
    }
    
    
    if(viewModel.scheduleItemViewModel == nil
       || viewModel.scheduleItemViewModel.isEnd) {
        cell.countdownLabel.text = @"";
    } else {
        cell.countdownLabel.text = [NSString stringWithFormat:@"%td",viewModel.scheduleItemViewModel.leftDay];
    }
    
    
    if (self.lk_forceTouchAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    
    static NSArray *weekdays;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekdays = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    });
    
    if ([kind isEqualToString:DayHeaderViewIdentifier]) {
        DayHeaderView *header = (DayHeaderView *)headerView;
        header.dayLabel.text = [self.viewModel.daysOfWeek objectAtIndex:indexPath.item];
        header.weekdayLabel.text = weekdays[indexPath.item];
        
        if (self.viewModel.isCurrentWeek
            && indexPath.item == [[NSDate date] weekdayAbsolute]) {
            [header setSelected:YES];
        } else {
            [header setSelected:NO];
        }
        
    } else if ([kind isEqualToString:SideHeaderViewIdentifier]) {
        SideHeaderView *header = (SideHeaderView *)headerView;
        header.titleLabel.text = [NSString stringWithFormat:@"%td", indexPath.item + 1];
    }
    

    return headerView;
}




#pragma mark - WeekCourseTableLayoutDataSource
- (CourseViewModel *)courseViewModelAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.courseViewModels[indexPath.item];
}

- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex
                                      maxDayIndex:(NSInteger)maxDayIndex
                                   minCourseIndex:(NSInteger)minCourseIndex
                                   maxCourseIndex:(NSInteger)maxCourseIndex {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.viewModel.courseViewModels enumerateObjectsUsingBlock:^(CourseViewModel *viewModel, NSUInteger idx, BOOL *stop) {
        if ([viewModel dayIndex] >= minDayIndex
            && [viewModel dayIndex] <= maxDayIndex
            && [viewModel startIndex] >= minCourseIndex
            && [viewModel startIndex] <= maxCourseIndex) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    return indexPaths;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)[previewingContext sourceView]];
    CourseViewModel *courseViewModel = self.viewModel.courseViewModels[indexPath.item];
    CourseDetailViewModel *detailViewModel = [[CourseDetailViewModel alloc] initWithCourseViewModel:courseViewModel];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc] initWithViewModel:detailViewModel];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - Private API
- (UIColor *)tryFetchColorFromSetForKey:(NSString *)key {
    UIColor *selectedColor = self.courseColorDict[key];
    if (selectedColor != nil) {
        return selectedColor;
    }
    
    NSInteger begin = arc4random() % self.colors.count;
    
    for (NSInteger i=0; i<self.colors.count; i++) {
        // 每次从随机的一个位置开始读
        begin = (begin + 1) % self.colors.count;
        UIColor *color = self.colors[begin];
        if (![self.usedColorSet containsObject:color]) {
            selectedColor = color;
            break;
        }
    }
    
    if(selectedColor == nil) {
        selectedColor = self.colors[arc4random() % self.colors.count];
    }
    
    return selectedColor;
}


#pragma mark - getter
- (YPMenuController *)menuController {
    if (_menuController == nil) {
        @weakify(self);
        NSInteger week = MAX(self.viewModel.week, 1);
        _menuController = [[YPMenuController alloc] initWithBlock:^(NSInteger index) {
            @strongify(self);
            self.viewModel.week = index + 1;
        } initialSelections:week - 1];
        _menuController.highlightedCellColor = LKColorLightBlue;
        
        [RACObserve(self.viewModel, originalWeek) subscribeNext:^(id x) {
            @strongify(self);
            NSInteger week = MAX([x integerValue], 1);
            NSMutableArray *weeks = [NSMutableArray arrayWithCapacity:25];
            for (NSInteger i=1; i<=25; i++) {
                [weeks addObject:[NSString stringWithFormat:@"第%td周",i]];
            }
            weeks[week-1] = [NSString stringWithFormat:@"第%td周(当前周)",week];
            self.menuController.items = [weeks copy];
            [self.viewModel resetWeek];
            [self.menuController selectIndex:week-1];
        }];
        
    }
    return _menuController;
}

- (CourseTableViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[CourseTableViewModel alloc] init];
    }
    return _viewModel;
}


- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        UIImage *backgroumdImage = [UIImage imageNamed:@"course_background"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroumdImage];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundImageView.alpha = 0.6;
        
    }
    return _backgroundImageView;
}

- (NSArray *)colors {
    if (_colors == nil) {
        _colors = @[UIColorFromRGB(0x63BA8E),
                    UIColorFromRGB(0x8FA6C7),
                    UIColorFromRGB(0xFEDC66),
                    UIColorFromRGB(0xC78783),
                    UIColorFromRGB(0x8EB94B),
                    UIColorFromRGB(0xC2AF71),
                    UIColorFromRGB(0x4FBDEA),
                    UIColorFromRGB(0xFE8783),];
    }
    return _colors;
}

- (NSMutableSet *)usedColorSet {
    if (_usedColorSet == nil) {
        _usedColorSet = [[NSMutableSet alloc] init];
    }
    return _usedColorSet;
}

- (NSMutableDictionary *)courseColorDict {
    if (_courseColorDict == nil) {
        _courseColorDict = [[NSMutableDictionary alloc] init];
    }
    return _courseColorDict;
}

@end
