//
//  LKNewsModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKNewsModule.h"
#import "LKNewsBrowser.h"
#import "NewsModel.h"
#import "NewsItemViewModel.h"
#import "Foundation+LKNewsExtension.h"
#import "NewsListViewController.h"
#import "NewsListAPIManager.h"
#import "NSDictionary+LKValueGetter.h"
#import "LKNewsSection.h"
@interface LKNewsModule()

@end
@implementation LKNewsModule

@end

@implementation LKNewsService
- (UIViewController *)LKNews_newsBrowser:(NSDictionary *)params {
    NewsModel *model = [[NewsModel alloc] init];
    model.title = [params stringForKey:@"title"];
    model.urlString = [params stringForKey:@"url"];
    model.date = [params stringForKey:@"date"];
    model.pageTitle = [params stringForKey:@"pageTitle"];
    
    NewsItemViewModel *viewModel = [[NewsItemViewModel alloc] initWithModel:model];
    return [[LKNewsBrowser alloc] initWithViewModel:viewModel];
}

- (UIViewController *)LKNews_newsListViewController:(NSDictionary *)params {
    return [[NewsListViewController alloc] init];
}

- (YLTableViewSection *)LKNews_newsSection:(NSDictionary *)params {
    return [[LKNewsSection alloc] init];
}
@end
