//
//  DepartmentsViewController.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"
#import "DepartmentsViewModel.h"
@interface DepartmentsViewController : UIViewController
- (instancetype)initWithViewModel:(DepartmentsViewModel *)viewModel;
@end
