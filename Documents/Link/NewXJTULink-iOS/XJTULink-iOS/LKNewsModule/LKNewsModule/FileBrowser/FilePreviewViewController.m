//
//  FilePreviewViewController.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/24.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "FilePreviewViewController.h"
#import "UMMobClick/MobClick.h"
@interface FilePreviewViewController ()

@end

@implementation FilePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setLeftBarButtonItem:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
