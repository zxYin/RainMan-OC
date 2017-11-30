//
//  DepartmentsViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "DepartmentModel.h"
@import UIKit.UIColor;
@interface DepartmentsViewModel : NSObject
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, assign) PageShowType type;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSArray<DepartmentModel *> *departments;
@end
