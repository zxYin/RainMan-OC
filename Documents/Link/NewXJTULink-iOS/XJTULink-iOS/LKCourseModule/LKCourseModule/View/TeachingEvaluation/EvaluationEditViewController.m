//
//  EvaluationEditViewController.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "EvaluationEditViewController.h"
#import "ViewsConfig.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EvalutionStarRateCell.h"
#import "TeachingAdviceCell.h"
typedef NS_ENUM(NSInteger, EvaluationEditSection) {
    EvaluationEditSectionGeneralComment,
    EvaluationEditSectionComment,
    EvaluationEditSectionStarRate,
};


@interface EvaluationEditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EvaluationEditViewModel *viewModel;
@end
@implementation EvaluationEditViewController
- (instancetype)initWithViewModel:(EvaluationEditViewModel *)viewModel {
    self = [super init];
    if(self) {
        self.viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.courseViewModel.name;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [[self.viewModel.networkingRAC requestCommand] execute:nil];
        [SVProgressHUD showWithStatus:@"正在提交"];
    }];
    
    [[self.viewModel.networkingRAC executionSignal] subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
        self.viewModel.courseViewModel.isEvluted = YES;
        self.viewModel.courseViewModel.count += 1;
        [AppContext showProgressFinishHUDWithMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.viewModel.networkingRAC requestErrorSignal] subscribeNext:^(YLResponseError *error) {
        [AppContext showProgressFailHUDWithMessage:error.message];
    }];
    
    
    RAC(submitItem, enabled) = RACObserve(self.viewModel, isValid);
    self.navigationItem.rightBarButtonItem = submitItem;
    
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.view endEditing:YES];
    }];
    [self.tableView addGestureRecognizer:tap];
    
    UINib *nib = [UINib nibWithNibName:@"EvalutionStarRateCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[EvalutionStarRateCell lk_identifier]];
    nib = [UINib nibWithNibName:@"TeachingAdviceCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[TeachingAdviceCell lk_identifier]];
    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == EvaluationEditSectionStarRate) {
        return self.viewModel.targets.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == EvaluationEditSectionStarRate) {
        return [tableView fd_heightForCellWithIdentifier:[EvalutionStarRateCell lk_identifier] configuration:^(EvalutionStarRateCell *cell) {
            cell.titleLabel.text = self.viewModel.targets[indexPath.row];
        }];
    }
    return TeachingAdviceCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case EvaluationEditSectionGeneralComment:
            title = @"总体评教";
            break;
        case EvaluationEditSectionComment:
            title = @"评教意见";
            break;
        case EvaluationEditSectionStarRate:
            title = @"评分";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    UITableViewCell *cell;
    switch (indexPath.section) {
        case EvaluationEditSectionGeneralComment: {
            TeachingAdviceCell *generalCommentCell = [tableView dequeueReusableCellWithIdentifier:[TeachingAdviceCell lk_identifier] forIndexPath:indexPath];
            generalCommentCell.textView.placeholder = @"请写下你的总体评教";
            RAC(self.viewModel, generalComment) = [generalCommentCell.textView.rac_textSignal takeUntil:generalCommentCell.rac_prepareForReuseSignal];
            
            cell = generalCommentCell;
            break;
        }
        case EvaluationEditSectionComment: {
            TeachingAdviceCell *commentCell = [tableView dequeueReusableCellWithIdentifier:[TeachingAdviceCell lk_identifier] forIndexPath:indexPath];
            commentCell.textView.placeholder = @"请写下你的评教意见";
            RAC(self.viewModel, comment) = [commentCell.textView.rac_textSignal takeUntil:commentCell.rac_prepareForReuseSignal];
            cell = commentCell;
            break;
        }
        case EvaluationEditSectionStarRate: {
            EvalutionStarRateCell *evalCell = [tableView dequeueReusableCellWithIdentifier:[EvalutionStarRateCell lk_identifier] forIndexPath:indexPath];
            CGFloat score = [self.viewModel.scores[indexPath.row] floatValue] / 5.0;
            evalCell.starRateView.scorePercent = score;
            evalCell.titleLabel.text = self.viewModel.targets[indexPath.row];
            [[[RACObserve(evalCell, rate) skip:1]
              takeUntil:evalCell.rac_prepareForReuseSignal]
             subscribeNext:^(id x) {
                 @strongify(self);
                 [self.viewModel setScore:[x integerValue] forIndex:indexPath.row];
            }];
            cell = evalCell;
            break;
        }
        default:
            break;
    }
    return cell;
}


- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
