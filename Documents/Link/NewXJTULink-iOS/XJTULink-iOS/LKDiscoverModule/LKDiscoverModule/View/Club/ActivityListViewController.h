//
//  ActivityListViewController.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListViewModel.h"
@interface ActivityListViewController : UIViewController
- (instancetype)initWithViewModel:(ActivityListViewModel *)viewModel;
@end
