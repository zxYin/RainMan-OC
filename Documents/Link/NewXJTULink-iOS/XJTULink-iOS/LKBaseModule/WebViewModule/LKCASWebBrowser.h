//
//  LKCASWebBrowser.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKWebBrowser.h"
@interface LKCASWebBrowser : LKWebBrowser

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title;
+ (LKCASWebBrowser *)webBrowserWithURL:(NSURL *)url title:(NSString *)title;
@end
