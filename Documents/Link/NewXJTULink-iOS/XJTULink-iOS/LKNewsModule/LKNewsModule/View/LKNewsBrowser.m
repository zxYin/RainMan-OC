//
//  LKNewsBrowser.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNewsBrowser.h"
#import "ViewsConfig.h"
#import "LKShareManager.h"
#import "FileTableViewController.h"
#import "Foundation+LKTools.h"
#import "AccessoryListViewController.h"
#import "FileTableViewController.h"
@interface LKNewsBrowser()<LKShareManagerDelegate>
@property (nonatomic, strong) NewsItemViewModel *viewModel;
@end

@implementation LKNewsBrowser
- (instancetype)initWithViewModel:(NewsItemViewModel *)viewModel {
    self = [super initWithURL:viewModel.url title:@"交大新闻"];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, title) =
    [RACObserve(self.viewModel, pageTitle) filter:^BOOL(id value) {
        return [NSString notBlank:value];
    }];
    
    
    if (self.viewModel.hasAccessory) {
        [self.basicWebPanelLine insertButtonWithTitle:@"附件" image:[UIImage imageNamed:@"option_icon_accessory"]  atIndex:0 handler:^(YLAlertPanelButton *button) {
            FileTableViewController *vc = [[FileTableViewController alloc] init];
            vc.news = self.viewModel.model;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    
}

- (void)shareManager:(LKShareManager *)manager didSelectShareAction:(NSString *)action {
    if ([action isEqualToString:LKShareActionNotCollect]) {
        [self.viewModel.model setFav:YES];
        [RKDropdownAlert title:@"收藏成功"];
        
    } else if([action isEqualToString:LKShareActionCollected]) {
        [self.viewModel.model setFav:NO];
        [RKDropdownAlert title:@"取消收藏"];
        
    } else if([action isEqualToString:LKShareActionAccessory]) {
        FileTableViewController *vc = [[FileTableViewController alloc]init];
        vc.news = self.viewModel.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)shareManagerExternActions {
    NSMutableArray *actions = [NSMutableArray array];
    if(self.viewModel.hasAccessory) {
        [actions addObject:LKShareActionAccessory];
    }
    if ([self.viewModel.model isFaved]) {
        [actions addObject:LKShareActionCollected];
    } else {
        [actions addObject:LKShareActionNotCollect];
    }
    return [actions copy];
}

@end
