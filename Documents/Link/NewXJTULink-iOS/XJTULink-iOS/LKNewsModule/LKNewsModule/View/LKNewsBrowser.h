//
//  LKNewsBrowser.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKWebBrowser.h"
#import "NewsItemViewModel.h"
@interface LKNewsBrowser : LKWebBrowser
- (instancetype)initWithViewModel:(NewsItemViewModel *)viewModel;
@end
