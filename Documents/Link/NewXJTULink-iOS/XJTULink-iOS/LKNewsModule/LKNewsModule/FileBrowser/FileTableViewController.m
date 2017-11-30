//
//  FileTableViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/20.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "FileTableViewController.h"
#import "FileListCell.h"
#import "AccessoryAPIManager.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "FilePreviewViewController.h"
#import <QuickLook/QuickLook.h>
#import "AccessoryModel.h"

@interface FileTableViewController ()<FileListCellDelegate,NSURLSessionDataDelegate,QLPreviewControllerDataSource,
YLAPIManagerDelegate,YLAPIManagerDataSource> {
    FileListCell *currentCell;
}
@property (strong,nonatomic) NSArray *fileList;
@property (strong,nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (strong,nonatomic) NSMutableDictionary *downloadedFiles;

@property (strong, nonatomic) AccessoryAPIManager *apiManager;

@property (strong,nonatomic) NSString *documentPath;
@end

@implementation FileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件";
    self.tableView.rowHeight = FileListCellHeight;
    self.tableView.allowsSelection = NO;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
    _documentPath =[documentPaths objectAtIndex:0];
    _downloadedFiles = [NSMutableDictionary dictionary];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.apiManager refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    UINib *nib = [UINib nibWithNibName:@"FileListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:FileListCellIdentifier];
    
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    return @{ kAccessoryAPIManagerParamsKeyNewsId : self.news.newsId };
    
}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)apiManager {
    self.fileList = [apiManager fetchDataFromModel:[AccessoryModel class]];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    
}
- (void)apiManager:(YLBaseAPIManager *)apiManager loadDataFail:(YLResponseError *)error {
    [self.tableView.mj_header endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileListCell *cell = [tableView dequeueReusableCellWithIdentifier:FileListCellIdentifier forIndexPath:indexPath];
    
    AccessoryModel *file =  _fileList[indexPath.row];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",file.title,file.type];
    cell.titleLabel.text = fileName;
//    cell.timeLabel.text = _news.date;
    cell.sourceLabel.text = @"教务处";
    cell.file = file;
    cell.delegate = self;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [_documentPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [cell downloadFinished];
        [_downloadedFiles setObject:[NSURL fileURLWithPath:filePath] forKey:cell.file.url.absoluteString];
        NSLog(@"%@ 文件已存在",fileName);
    } else {
        NSLog(@"%@ 文件不存在",fileName);
    }
    
    
    
    return cell;
}

- (void)downloadButtonDidClick:(FileListCell *)cell {
    switch (cell.status) {
        case FileNetworkStatusDownloading: {
            [cell downloadStart];
            NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                                    diskCapacity:5 * 1024 * 1024
                                                                        diskPath:nil];
            [NSURLCache setSharedURLCache:sharedCache];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL = cell.file.url;
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSString *filename = [NSString stringWithFormat:@"%@.%@",cell.file.title,cell.file.type];
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:filename];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                [cell downloadFinished];
                [_downloadedFiles setObject:filePath forKey:cell.file.url.absoluteString];
            }];
            [cell.progressView setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
            [downloadTask resume];
            break;
        }
            
        case FileNetworkStatusFinished: {
            currentCell = cell;
            QLPreviewController *controller = [[QLPreviewController alloc]initWithNibName:nil bundle:nil];
//            controller.navigationController.navigationBarHidden = YES;
            controller.navigationController.navigationBar.translucent = NO;
            controller.title = cell.file.title;
            controller.dataSource = self;
            [controller setCurrentPreviewItemIndex:0];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
    
    

}
#pragma mark - quicklook
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [_downloadedFiles objectForKey:currentCell.file.url.absoluteString];
}

- (AccessoryAPIManager *)apiManager {
    if (_apiManager == nil) {
        _apiManager = [AccessoryAPIManager new];
        _apiManager.delegate = self;
        _apiManager.dataSource = self;
    }
    return _apiManager;
}

@end
