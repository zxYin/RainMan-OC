//
//  ScheduleNameListViewController.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/14.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleNameListViewController.h"
#import "ViewsConfig.h"
#import "CourseManager.h"

@interface ScheduleNameListViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *underLine;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) NSArray<CourseModel *> *viewModel;
@end

@implementation ScheduleNameListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"课程列表";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.cancelButton];
    [self.textField addSubview:self.underLine];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).offset(5);
        make.centerY.mas_equalTo(self.textField);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textField).offset(-1);
        make.left.mas_equalTo(self.textField);
        make.right.mas_equalTo(self.textField);
        make.height.mas_equalTo(2);
    }];
    [self.cancelButton bk_addEventHandler:^(id sender) {
        [self back];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupRAC];
}

- (void)setupRAC {
    CourseManager *manager = [CourseManager sharedInstance];
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    [RACObserve(manager, courseTable) subscribeNext:^(id x) {
        self.viewModel = manager.courseList;
    }];
    
    [self.textField.rac_textSignal subscribeNext:^(NSString *value) {
        NSString *text = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (text.length > 0) {
            NSMutableArray *filterViewModel = [NSMutableArray array];
            CourseModel *courseModel = [[CourseModel alloc] init];
            courseModel.name = text;
            [filterViewModel addObject:courseModel];
            
            for (CourseModel *model in manager.courseList) {
                if ([[model.name uppercaseString] containsString:[text uppercaseString]]) {
                    [filterViewModel addObject:model];
                }
            }
            self.viewModel = filterViewModel;
        } else {
            self.viewModel = manager.courseList;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateLayoutIsEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.viewModel[indexPath.row].name;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseModel *courseModel = self.viewModel[indexPath.row];
    if (courseModel) {
        if ([self.delegate respondsToSelector:@selector(scheduleNameListViewController:didSelectAtCourseName:)]) {
            [self.delegate scheduleNameListViewController:self didSelectAtCourseName:courseModel.name];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self updateLayoutIsEditing:YES];
}

#pragma mark - private 
- (void)updateLayoutIsEditing:(BOOL)isEditing {
    if (isEditing) {
        self.cancelButton.hidden = NO;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-50);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-10);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.cancelButton.hidden = YES;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)info {
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight =  keyboardBounds.size.height;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, keyboardHeight, 0));
    }];
    [self.view layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification *)info {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - getter

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"搜索考试名称";
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)underLine {
    if (_underLine == nil) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _underLine;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}

@end
