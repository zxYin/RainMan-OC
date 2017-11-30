//
//  ScheduleEditViewController.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleEditViewController.h"
#import "ScheduleEditViewModel.h"
#import "ViewsConfig.h"
#import "UITableView+YLExpandable.h"
#import "ScheduleEditCell.h"
#import "ScheduleDatePickerCell.h"
#import "ColorMacros.h"
#import "ScheduleManager.h"
#import "AppContext.h"
#import "ScheduleNameListViewController.h"

@interface ScheduleEditViewController ()<UITableViewDelegate, UITableViewDataSource, YLExpandableDataSource,YLExpandableDeleagte, ScheduleNameListViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ScheduleEditViewModel *viewModel;
@property (nonatomic, strong) ScheduleModel *oldModel;

@property (nonatomic, copy) NSArray<ScheduleEditCell *> *scheduleEditCells;
@property (nonatomic, strong) UISearchController *searchViewController;
@end

@implementation ScheduleEditViewController

- (instancetype)initWithViewModel:(ScheduleEditViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _oldModel = [viewModel.scheduleModel copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (self.viewModel.type == ScheduleEditViewModelTypeUpdate)? @"编辑考试": @"添加考试";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
        if (self.viewModel.type == ScheduleEditViewModelTypeAdd) {
            if ([[ScheduleManager sharedInstance] fetchScheduleModelForKey:self.viewModel.scheduleModel.name]) {
                [AppContext showError:@"该考试已存在"];
                return;
            }
            
            [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleAdd] requestCommand] execute:nil];
        } else if (self.viewModel.type == ScheduleEditViewModelTypeUpdate) {
            ScheduleModel *model = [[ScheduleManager sharedInstance] fetchScheduleModelForKey:self.viewModel.scheduleModel.name];
            if (model && ![self.viewModel.scheduleModel.name isEqualToString:self.oldModel.name]) {
                [AppContext showError:@"该考试已存在"];
                return;
            }
            
            [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleUpdate] requestCommand] execute:nil];
        }
        
        [SVProgressHUD showWithStatus:@"正在提交"];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib *nib = [UINib nibWithNibName:@"ScheduleDatePickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ScheduleDatePickerCell lk_identifier]];
    
    [self setupRAC];
    
    RAC(submitItem, enabled) = RACObserve(self.viewModel, isValid);
    self.navigationItem.rightBarButtonItem = submitItem;
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleAdd] executionSignal] subscribeNext:^(id x) {
        [AppContext dismissProgressLoading];
        [AppContext showProgressFinishHUDWithMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleUpdate] executionSignal] subscribeNext:^(id x) {
        [AppContext dismissProgressLoading];
        [AppContext showProgressFinishHUDWithMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleAdd] requestErrorSignal] subscribeNext:^(YLResponseError *error) {
        [AppContext showProgressFailHUDWithMessage:error.message];
    }];
    
    [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleUpdate] requestErrorSignal] subscribeNext:^(YLResponseError *error) {
        [AppContext showProgressFailHUDWithMessage:error.message];
    }];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.view endEditing:YES];
    }];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


- (void)setupRAC {
    RAC(self.scheduleEditCells[kScheduleEditCellName].textFieldView, text) = RACObserve(self.viewModel, scheduleModel.name);
    RAC(self.scheduleEditCells[kScheduleEditCellTime].textFieldView, text) = RACObserve(self.viewModel, scheduleModel.time);
    RAC(self.scheduleEditCells[kScheduleEditCellLocale].textFieldView, text) = RACObserve(self.viewModel, scheduleModel.locale);

    [self.scheduleEditCells[kScheduleEditCellName].textFieldView.rac_textSignal subscribeNext:^(id x) {
        self.viewModel.scheduleModel.name = self.scheduleEditCells[kScheduleEditCellName].textFieldView.text;
    }];
    [self.scheduleEditCells[kScheduleEditCellTime].textFieldView.rac_textSignal subscribeNext:^(id x) {
        self.viewModel.scheduleModel.time = self.scheduleEditCells[kScheduleEditCellTime].textFieldView.text;
    }];
    [self.scheduleEditCells[kScheduleEditCellLocale].textFieldView.rac_textSignal subscribeNext:^(id x) {
        self.viewModel.scheduleModel.locale = self.scheduleEditCells[kScheduleEditCellLocale].textFieldView.text;
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.viewModel.type == ScheduleEditViewModelTypeAdd)? [self.scheduleEditCells count]: [self.scheduleEditCells count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kScheduleEditCellName) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case kScheduleEditCellName: {
            if (indexPath.row == 0) {
                cell = self.scheduleEditCells[kScheduleEditCellName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"从课表选择";
            }
            break;
        }
            
        case kScheduleEditCellTime: {
            cell = self.scheduleEditCells[kScheduleEditCellTime];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yl_expandable = YES;
            break;
        }
            
        case kScheduleEditCellLocale: {
            cell = self.scheduleEditCells[kScheduleEditCellLocale];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case kScheduleEditDeleteCell: {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ScheduleEditDeleteCell" owner:self options:nil].lastObject;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kScheduleEditCellName) {
        if (indexPath.row == 1) {
            ScheduleNameListViewController *vc = [[ScheduleNameListViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == kScheduleEditDeleteCell) {
        TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
        actionSheet.title = @"确认删除这场考试吗？";
        @weakify(self);
        [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
            @strongify(self);
            [[ScheduleManager sharedInstance] deleteScheduleModelWithEventId:self.viewModel.scheduleModel.eventId];
            [[self.viewModel.networkingRACs[kNetworkingRACTypeScheduleDelete] requestCommand] execute:nil];
            [AppContext showProgressFinishHUDWithMessage:@"删除成功"];
            [self back];
        }];
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        [actionSheet show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YLExpandableDataSource
- (UITableViewCell *)yl_tableView:(UITableView *)tableView expandCellForHostIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kScheduleEditCellTime) {
        ScheduleDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScheduleDatePickerCell lk_identifier] forIndexPath:indexPath];
        if (self.viewModel.scheduleModel.time.length > 0) {
            [cell.datePicker setDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.scheduleModel.timestamp]];
        }
        
        RAC(self.viewModel, scheduleModel.time) = [[RACObserve(cell, date) takeUntil:cell.rac_prepareForReuseSignal] map:^id(id value) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            formatter.timeZone = [NSTimeZone systemTimeZone];
            return [formatter stringFromDate:cell.date];
        }];
        return cell;
    }
    return nil;
}

- (CGFloat)yl_tableView:(UITableView *)tableView heightOfExpandCellForHostIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - YLExpandableDeleagte

- (void)yl_tableView:(UITableView *)tableView didExpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已展开");
}

- (void)yl_tableView:(UITableView *)tableView didUnexpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已收回");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ScheduleNameListViewControllerDelegate
- (void)scheduleNameListViewController:(ScheduleNameListViewController *)viewController didSelectAtCourseName:(NSString *)name {
    self.viewModel.scheduleModel.name = name;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.yl_expandableDelegate = self;
        _tableView.yl_expandableDataSource = self;
        
        _tableView.yl_expandable = YES; // this must declare before setting dataSource and delegate
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)scheduleEditCells {
    if (_scheduleEditCells == nil) {
        ScheduleEditCell *nameCell = [[NSBundle mainBundle] loadNibNamed:@"ScheduleEditCell" owner:self options:nil].lastObject;
        nameCell.textFieldView.placeholder = @"考试名称";
        nameCell.iconImageView.image = [UIImage imageNamed:@"course_name_icon_normal"];
        self.searchViewController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        ScheduleEditCell *timeCell = [[NSBundle mainBundle] loadNibNamed:@"ScheduleEditCell" owner:self options:nil].lastObject;
        timeCell.textFieldView.placeholder = @"考试时间";
        timeCell.textFieldView.enabled = NO;
        timeCell.iconImageView.image = [UIImage imageNamed:@"course_time_icon_normal"];
        
        ScheduleEditCell *localeCell = [[NSBundle mainBundle] loadNibNamed:@"ScheduleEditCell" owner:self options:nil].lastObject;
        localeCell.textFieldView.placeholder = @"考试地点(可选)";
        localeCell.iconImageView.image = [UIImage imageNamed:@"course_locale_icon_normal"];
        _scheduleEditCells = @[nameCell, timeCell, localeCell];
    }
    return _scheduleEditCells;
}

@end
