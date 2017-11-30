//
//  AppMediator+LKNewsModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "YLTableView.h"

@interface AppMediator (LKNewsModule)
- (UIViewController *)LKNews_newsListViewController;
- (YLTableViewSection *)LKNews_newsSection;

- (UIViewController *)LKNews_newsBrowserWithURL:(NSString *)url
                                          title:(NSString *)title
                                           date:(NSString *)date
                                      pageTitle:(NSString *)pageTitle;

@end
