//
//  AccessoryListViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AccessoryListViewController.h"
#import "ViewsConfig.h"
#import "FileListCell.h"
#import "AFNetworking.h"
#import "FilePreviewViewController.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface AccessoryListViewController()<UITableViewDelegate, UITableViewDataSource,LKEmptyManagerDelegate,FileListCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) AccessoryListViewModel *viewModel;
@property (nonatomic, strong) LKEmptyManager *emptyManager;

@end
@implementation AccessoryListViewController
- (instancetype)initWithViewModel:(AccessoryListViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"附件列表";
    [self.view addSubview:self.tableView];
    
    
    @weakify(self);
    [[[RACObserve(self.viewModel, accessoryModels) skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.emptyManager reloadEmptyDataSet];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
    
    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         [self.emptyManager reloadEmptyDataSet];
         [RKDropdownAlert title:@"网络错误"];
         [self.tableView.mj_header endRefreshing];
     }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.edgesForExtendedLayout = NO;
    
    UINib *nib = [UINib nibWithNibName:@"FileListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[FileListCell lk_identifier]];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.accessoryModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FileListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListCell *cell = [tableView dequeueReusableCellWithIdentifier:[FileListCell lk_identifier] forIndexPath:indexPath];
    
    AccessoryModel *file =  self.viewModel.accessoryModels[indexPath.row];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",file.title,file.type];
    cell.titleLabel.text = fileName;
    cell.sourceLabel.text = @"教务处";
    cell.delegate = self;
    
    if ([self.viewModel fileExistsByName:fileName]) {
        
//        [cell downloadFinished];
    
//        [self.viewModel.downloadedFiles setObject:file.url forKey:cell.file.url];
    }

    return cell;
}

- (void)downloadButtonDidClick:(FileListCell *)cell {
    
}
#pragma mark - quicklook
- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *) controller {
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
//    return [self.viewModel.downloadedFiles objectForKey:currentCell.file.url];
    return nil;
}


#pragma mark - getter && setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.requestCommand];
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (LKEmptyManager *)emptyManager {
    if (_emptyManager == nil) {
        _emptyManager = LKEmptyManagerWith(self.tableView, LKEmptyManagerStyleNoData);
        _emptyManager.delegate = self;
    }
    return _emptyManager;
}



@end
