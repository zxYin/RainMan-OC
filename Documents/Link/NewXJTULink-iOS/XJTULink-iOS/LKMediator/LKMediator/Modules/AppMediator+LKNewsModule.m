//
//  AppMediator+LKNewsModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKNewsModule.h"
NSString * const kAppMediatorNewsModule= @"LKNewsModule";

NSString * const kAppMediatorNewsServiceNewsSection = @"newsSection";
NSString * const kAppMediatorNewsServiceNewsListViewController = @"newsListViewController";
NSString * const kAppMediatorNewsServiceNewsBrowser = @"newsBrowser";

@implementation AppMediator (LKNewsModule)

+ (void)load {
    LKModule(@"news", kAppMediatorNewsModule);
    
    /**
     打开新闻
     @param url         链接
     @param title       新闻标题（可选）
     @param date        日期（可选）
     @param pageTitle   页面标题（可选）
     */
    LKRoute(@"/", kAppMediatorNewsServiceNewsBrowser, kAppMediatorNewsModule);
    
}


- (UIViewController *)LKNews_newsListViewController {
    return [[self performAction:kAppMediatorNewsServiceNewsListViewController
                      onModule:kAppMediatorNewsModule
                        params:nil]
            safeType:[UIViewController class]];
}


- (YLTableViewSection *)LKNews_newsSection {
    return [[self performAction:kAppMediatorNewsServiceNewsSection
                       onModule:kAppMediatorNewsModule
                         params:nil]
            safeType:[YLTableViewSection class]];
}


- (UIViewController *)LKNews_newsBrowserWithURL:(NSString *)url title:(NSString *)title date:(NSString *)date pageTitle:(NSString *)pageTitle {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"url"] = url;
    params[@"title"] = title;
    params[@"date"] = date;
    params[@"pageTitle"] = pageTitle;
    
    return [[self performAction:kAppMediatorNewsServiceNewsBrowser
                       onModule:kAppMediatorNewsModule
                         params:[params copy]]
            safeType:[UIViewController class]];
}
@end
