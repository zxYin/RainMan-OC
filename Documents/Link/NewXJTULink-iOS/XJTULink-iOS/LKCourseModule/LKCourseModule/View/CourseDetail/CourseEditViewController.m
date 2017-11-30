//
//  CourseEditViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseEditViewController.h"
#import "ViewsConfig.h"
#import "LKInputCell.h"
#import "CourseDeleteCell.h"
#import "Foundation+LKTools.h"
#import "TBActionSheet.h"
#import "CourseTimePickerCell.h"
#import "Foundation+LKCourse.h"
#import "AppContext.h"
#import "UITableView+YLExpandable.h"
#import "Constants.h"
#import "SimpleCourseWeekPickerCell.h"

static NSInteger const CellTextFieldBaseTag = 1000;

@interface CourseEditViewController ()<UITableViewDelegate, UITableViewDataSource,YLExpandableDataSource,YLExpandableDeleagte, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CourseEditViewModel *viewModel;

@end

@implementation CourseEditViewController

- (instancetype)initWithViewModel:(CourseEditViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"编辑课程";
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self.viewModel.isConflict) {
            [AppContext showProgressFailHUDWithMessage:@"课程冲突，保存失败"];
        } else {
            [self.viewModel saveToCourseTable];
            [AppContext showProgressFinishHUDWithMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    UINib *nib = [UINib nibWithNibName:@"LKInputCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[LKInputCell lk_identifier]];
    
    nib = [UINib nibWithNibName:@"CourseTimePickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CourseTimePickerCell lk_identifier]];
    
    nib = [UINib nibWithNibName:@"CourseDeleteCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[CourseDeleteCell lk_identifier]];
    
    nib = [UINib nibWithNibName:@"SimpleCourseWeekPickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[SimpleCourseWeekPickerCell lk_identifier]];
    
    
    [self setupRAC];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.view endEditing:YES];
    }];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)setupRAC {
    @weakify(self);
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) =
    [RACObserve(self.viewModel.model, name) map:^id(id value) {
        return @([value length]>0);
    }];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (5 + (self.viewModel.isNew?0:1));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kCourseEditItemTeachers) {
        return self.viewModel.model.teachers.count + 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.viewModel.isNew && indexPath.section == kCourseEditItemDelete) {
        return [tableView dequeueReusableCellWithIdentifier:[CourseDeleteCell lk_identifier] forIndexPath:indexPath];
    }
    
    LKInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[LKInputCell lk_identifier] forIndexPath:indexPath];
    @weakify(self);
    
    switch (indexPath.section) {
        case kCourseEditItemName: {
            RAC(cell.infoTextField, text) =
            [RACObserve(self.viewModel.model, name) takeUntil:cell.rac_prepareForReuseSignal];
            cell.iconImageView.image = [UIImage imageNamed:@"course_name_icon_normal"];
            
            cell.infoTextField.placeholder = @"课程名称";
            cell.infoTextField.enabled = YES;
            cell.yl_expandable = NO;
            break;
        }
            
        case kCourseEditItemLocale:{
            RAC(cell.infoTextField, text) =
            [RACObserve(self.viewModel.model, locale) takeUntil:cell.rac_prepareForReuseSignal];
            cell.iconImageView.image = [UIImage imageNamed:@"course_time_icon_normal"];
            
            cell.infoTextField.placeholder = @"上课地点";
            cell.infoTextField.enabled = YES;
            cell.yl_expandable = NO;
            break;
        }
            
        case kCourseEditItemTeachers:{
            [[RACObserve(self.viewModel.model, teachers)
              takeUntil:cell.rac_prepareForReuseSignal]
             subscribeNext:^(id x) {
                 @strongify(self);
                 if (indexPath.row < self.viewModel.model.teachers.count) {
                     cell.infoTextField.text = self.viewModel.model.teachers[indexPath.row];
                 } else {
                     cell.infoTextField.text = @"";
                 }
                 
            }];
            cell.iconImageView.image = [UIImage imageNamed:@"course_teacher_icon_normal"];
            
            if(indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
                cell.infoTextField.enabled = NO;
            } else {
                cell.infoTextField.placeholder = @"添加任课老师";
                cell.infoTextField.enabled = YES;
            }
            cell.yl_expandable = NO;
            
            break;
        }
            
        case kCourseEditItemTime:{
            
            RAC(cell.infoTextField, text) =
            [RACObserve(self.viewModel, time) takeUntil:cell.rac_prepareForReuseSignal];
            cell.iconImageView.image = [UIImage imageNamed:@"course_time_icon_normal"];
            
            cell.infoTextField.enabled = NO;
            cell.yl_expandable = YES;
            break;
        }
            
        case kCourseEditItemWeek:{
            RAC(cell.infoTextField, text) =
            [RACObserve(self.viewModel, weeks) takeUntil:cell.rac_prepareForReuseSignal];
            cell.iconImageView.image = [UIImage imageNamed:@"course_week_icon_normal"];
            
            cell.infoTextField.enabled = NO;
            cell.yl_expandable = YES;
            break;
        }
            
        default:
            break;
    }
    
    if (indexPath.row != 0) {
        cell.iconImageView.image = nil;
    }
    
    cell.infoTextField.delegate = self;
    cell.infoTextField.tag = CellTextFieldBaseTag + indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKInputCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case kCourseEditItemTeachers: {
            if(indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
                TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
                actionSheet.title = @"确认删除此任课老师吗？";
                @weakify(self);
                [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
                    @strongify(self);
                    
                    NSMutableArray *teachers = [NSMutableArray arrayWithArray:self.viewModel.model.teachers];
                    [teachers removeObjectAtIndex:indexPath.row];
                    self.viewModel.model.teachers = [teachers copy];
                    if (indexPath.row == 0) {
                        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:1 inSection:kCourseEditItemTeachers];
                        LKInputCell *nextCell = [tableView cellForRowAtIndexPath:nextIndexPath];
                        nextCell.iconImageView.image = cell.iconImageView.image;
                    }
                    
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                    
                }];
                
                [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
                
                [actionSheet show];
            }
            break;
        }
        case kCourseEditItemDelete: {
            TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
            actionSheet.title = @"确认删除这节课吗？";
            @weakify(self);
            [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
                @strongify(self);
                [self.viewModel removeFromCourseTable];
                [AppContext showProgressFinishHUDWithMessage:@"删除成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
            [actionSheet show];
            break;
        }
            
        default:
            break;
    }
    
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([NSString isBlank:textField.text]) {
        return;
    }
    
    switch (textField.tag - CellTextFieldBaseTag) {
        case kCourseEditItemName:
            self.viewModel.model.name = textField.text;
            break;
        case kCourseEditItemLocale:
            self.viewModel.model.locale = textField.text;
            break;
            
        case kCourseEditItemTeachers: {
            NSArray *teachers = self.viewModel.model.teachers;
            if (teachers.count == 0) {
                LKInputCell *cell = (LKInputCell *)[[textField superview] superview];
                cell.iconImageView.image = nil;
            }
            
            if (teachers) {
                self.viewModel.model.teachers = [teachers arrayByAddingObject:textField.text];
            } else {
                self.viewModel.model.teachers = @[textField.text];
            }
            
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:teachers.count inSection:kCourseEditItemTeachers]] withRowAnimation:UITableViewRowAnimationBottom];
            textField.text = @"";
            break;
        }
        default:
            break;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - YLExpandableDataSource

- (UITableViewCell *)yl_tableView:(UITableView *)tableView expandCellForHostIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kCourseEditItemTime) {
        CourseTimePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseTimePickerCellIdentifier forIndexPath:indexPath];
        cell.weekday = self.viewModel.model.weekday;
        cell.start = self.viewModel.model.timeRange.location;
        cell.end = NSMaxRange(self.viewModel.model.timeRange) - 1;
        
        RAC(self.viewModel.model, weekday) =
        [RACObserve(cell, weekday) takeUntil:cell.rac_prepareForReuseSignal];
        RAC(self.viewModel.model, timeRange) =
        [[[RACSignal merge:@[RACObserve(cell, start),
                            RACObserve(cell, end)]]
          takeUntil:cell.rac_prepareForReuseSignal]
          map:^id(id value) {
            return [NSValue valueWithRange:NSMakeRange(cell.start, cell.end-cell.start+1)];
        }];
        return cell;
    } else if(indexPath.section == kCourseEditItemWeek) {
        SimpleCourseWeekPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[SimpleCourseWeekPickerCell lk_identifier] forIndexPath:indexPath];
        cell.type = self.viewModel.model.weekFormatter.type;
        cell.start = 1;
        cell.end = 16;
        
        @weakify(self);
        RAC(self.viewModel.model, weekFormatter) =
        [[[RACSignal merge:@[RACObserve(cell, type),
                             RACObserve(cell, start),
                             RACObserve(cell, end)]]
          takeUntil:cell.rac_prepareForReuseSignal]
         map:^id(id value) {
             @strongify(self);
             NSString *type = @"";
             switch (cell.type) {
                 case WeekTypeCustom:
                     type = @"";
                     break;
                 case WeekTypeOdd:
                     type = @"单";
                     break;
                 case WeekTypeEven:
                     type = @"双";
                     break;
                 default:
                     break;
             }
             
             NSString *week = [NSString stringWithFormat:@"%@ %td-%td",type, cell.start, cell.end];
             self.viewModel.model.week = week;
             return [WeekFormatter formatterWithString:week];
         }];
        return cell;
    }
    return nil;
}

- (CGFloat)yl_tableView:(UITableView *)tableView heightOfExpandCellForHostIndexPath:(NSIndexPath *)indexPath {
    return CourseTimePickerCellHeight;
}

#pragma mark - YLExpandableDeleagte

- (void)yl_tableView:(UITableView *)tableView didExpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已展开");
}

- (void)yl_tableView:(UITableView *)tableView didUnexpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已收回");
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

@end
