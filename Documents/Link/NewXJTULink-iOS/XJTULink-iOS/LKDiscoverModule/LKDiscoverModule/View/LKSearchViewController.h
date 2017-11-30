//
//  SearchResultViewController.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchBar.h"
@interface LKSearchViewController : UIViewController
@property (nonatomic, assign) BOOL hideBackButton;
@property (nonatomic, assign) BOOL animateEnable;
- (instancetype)initWithPlaceholder:(NSString *)placeholder;
@end
