//
//  CourseDetailViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ViewsConfig.h"
#import "CourseDetailCell.h"
#import "CourseDetailHeaderView.h"
#import "CourseEditViewController.h"

#import "UIViewController+Helper.h"
#import "ScheduleItemCell.h"
#import "ScheduleEditViewModel.h"
#import "ScheduleEditViewController.h"

@interface CourseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CourseDetailViewModel *viewModel;

@property (nonatomic, strong) CourseDetailHeaderView *headerView;
@end

@implementation CourseDetailViewController

- (instancetype)initWithViewModel:(CourseDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"course_edit_nav_normal"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        CourseEditViewModel *viewModel = [[CourseEditViewModel alloc] initWithModel:self.viewModel.courseViewModel.model];
        CourseEditViewController *vc = [[CourseEditViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(CourseDetailHeaderViewHeight, 0, 0, 0);
    
    UINib *nib = [UINib nibWithNibName:@"CourseDetailCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CourseDetailCellIdentifier];
    UINib *snib = [UINib nibWithNibName:@"ScheduleItemCell" bundle:nil];
    [self.tableView registerNib:snib forCellReuseIdentifier:[ScheduleItemCell lk_identifier]];
    
    [self setupRAC];
    
}


- (void)setupRAC {
    RAC(self.headerView.titleLabel, text) = RACObserve(self.viewModel, title);
    
    @weakify(self);
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headerView.frame = CGRectMake(0, 0, MainScreenSize.width, CourseDetailHeaderViewHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.viewModel.scheduleItemViewModel == nil)?1:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.scheduleItemViewModel != nil
        && section == 0) {
        return 1;
    }
    return self.viewModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.viewModel.scheduleItemViewModel != nil
       && indexPath.section == 0) {
        ScheduleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleItemCell.lk_identifier forIndexPath:indexPath];
        cell.title = @"考试";
        cell.viewModel = self.viewModel.scheduleItemViewModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseDetailCellIdentifier forIndexPath:indexPath];
    
    cell.iconImageView.image = self.viewModel.items[indexPath.row][kCourseDetailItemKeyIcon];
    cell.titleLabel.text = self.viewModel.items[indexPath.row][kCourseDetailItemKeyText];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewModel.scheduleItemViewModel != nil
        && section == 0) {
        return 5;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.scheduleItemViewModel != nil
        && indexPath.section == 0) {
        return ScheduleItemCellHeight;
    }
    return CourseDetailCellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.scheduleItemViewModel != nil
        && indexPath.section == 0) {
        ScheduleEditViewModel *viewModel = [[ScheduleEditViewModel alloc] initWithType:ScheduleEditViewModelTypeUpdate];
        viewModel.scheduleModel.eventId = self.viewModel.scheduleItemViewModel.eventId;
        viewModel.scheduleModel.name = self.viewModel.scheduleItemViewModel.name;
        NSString *locale = self.viewModel.scheduleItemViewModel.locale;
        if ([locale isEqualToString:@"(未设置)"]) {
            locale = @"";
        }
        viewModel.scheduleModel.locale = locale;
        viewModel.scheduleModel.time = self.viewModel.scheduleItemViewModel.time;
        
        ScheduleEditViewController *vc = [[ScheduleEditViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < - CourseDetailHeaderViewHeight) {
        CGRect frame = self.headerView.frame;
        frame.size.height = fabs(offset);
        frame.origin.y = 0;
        self.headerView.frame = frame;
    } else {
        CGRect frame = self.headerView.frame;
        frame.origin.y = -(CourseDetailHeaderViewHeight + offset);
        frame.size.height = CourseDetailHeaderViewHeight;
        self.headerView.frame = frame;
    }
}



#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (CourseDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [CourseDetailHeaderView headerView];
    }
    return _headerView;
}

@end
