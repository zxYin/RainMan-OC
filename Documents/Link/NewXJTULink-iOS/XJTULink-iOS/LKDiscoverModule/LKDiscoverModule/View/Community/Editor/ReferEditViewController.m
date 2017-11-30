//
//  ReferEditViewController.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/4.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ReferEditViewController.h"
#import "UITableView+YLExpandable.h"
#import "LKInputCell.h"
#import "ViewsConfig.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "AcademyPickerCell.h"
#import "CommunityContext.h"
#import "AcademyManager.h"

static NSInteger const CellTextFieldBaseTag = 1000;

@interface ReferEditViewController ()<UITableViewDelegate, UITableViewDataSource,YLExpandableDataSource,YLExpandableDeleagte, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isCancel) BOOL cancel;
@end

@implementation ReferEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancel = YES;
    CommunityContext *context = [CommunityContext currentContext];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:context.tintColor];
    self.title = @"选择提醒对象";
    
    if([NSString isBlank:self.referAcademy]) {
        self.referAcademy = kAcademyNotSet;
    }
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        self.cancel = YES;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        self.cancel = NO;
        if ([self.referAcademy isEqualToString:kAcademyNotSet]) {
            self.referAcademy = nil;
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) =
    [RACObserve(self, referName) map:^id(NSString *name) {
        return @([NSString notBlank:[name stringByTrimmingDefault]]);
    }];
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib *nib = [UINib nibWithNibName:@"LKInputCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[LKInputCell lk_identifier]];
    
    nib = [UINib nibWithNibName:@"AcademyPickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[AcademyPickerCell lk_identifier]];

    [self setupRAC];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.view endEditing:YES];
    }];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)setupRAC {
    
//    RAC(self.navigationItem.rightBarButtonItem, enabled) =
//    [RACObserve(self.viewModel.model, name) map:^id(id value) {
//        return @([value length]>0);
//    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.finish) {
        NSString *referAcademy = self.referAcademy;
        if ([referAcademy isEqualToString:kAcademyNotSet]) {
            referAcademy = nil;
        }
        self.finish(!self.isCancel, self.referName, referAcademy, self.referClass);
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[LKInputCell lk_identifier] forIndexPath:indexPath];
    @weakify(self);
    switch (indexPath.section) {
        case kReferEditItemName: {
            cell.infoTextField.text = self.referName;
            [[cell.infoTextField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal]
             subscribeNext:^(id x) {
                 @strongify(self);
                self.referName = x;
            }];
            
            cell.iconImageView.image = [UIImage imageNamed:@"icon_person"];
            
            cell.infoTextField.placeholder = @"姓名";
            cell.infoTextField.enabled = YES;
            cell.yl_expandable = NO;
            break;
        }
            
        case kReferEditItemAcademy:{
            RAC(cell.infoTextField, text) =
            [RACObserve(self, referAcademy) takeUntil:cell.rac_prepareForReuseSignal];
            cell.iconImageView.image = [UIImage imageNamed:@"icon_academy"];
            cell.infoTextField.enabled = NO;
            cell.yl_expandable = YES;
            break;
        }
            
        case kReferEditItemClass:{
            cell.infoTextField.text = self.referClass;
            [[cell.infoTextField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal]
             subscribeNext:^(id x) {
                 @strongify(self);
                 self.referClass = x;
            }];
            cell.iconImageView.image = [UIImage imageNamed:@"icon_class"];
            cell.infoTextField.placeholder = @"班级(可选)，如: 软件00";
            cell.infoTextField.enabled = YES;
            cell.yl_expandable = NO;
            break;
        }
            
        default:
            break;
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
//    LKInputCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - YLExpandableDataSource

- (UITableViewCell *)yl_tableView:(UITableView *)tableView expandCellForHostIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kReferEditItemAcademy) {
        AcademyPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[AcademyPickerCell lk_identifier] forIndexPath:indexPath];
        cell.selectedAcademy = self.referAcademy;
        
        RAC(self, referAcademy) =
        [RACObserve(cell, selectedAcademy) takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }
    return nil;
}

- (CGFloat)yl_tableView:(UITableView *)tableView heightOfExpandCellForHostIndexPath:(NSIndexPath *)indexPath {
    return AcademyPickerCelllHeight;
}

#pragma mark - YLExpandableDeleagte

- (void)yl_tableView:(UITableView *)tableView didExpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已展开");
}

- (void)yl_tableView:(UITableView *)tableView didUnexpandForHostIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已收回");
}

#pragma mark - Private API


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

- (NSString *)referAcademy {
    if (_referAcademy == nil) {
        _referAcademy = kAcademyNotSet;
    }
    return _referAcademy;
}

@end
