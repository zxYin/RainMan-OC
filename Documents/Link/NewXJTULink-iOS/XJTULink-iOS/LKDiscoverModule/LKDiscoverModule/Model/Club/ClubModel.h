//
//  ClubModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepartmentModel.h"
#import "Constants.h"

@interface ClubModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *clubId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, assign) PageShowType showType;
@property (nonatomic, copy) NSURL *webURL;
@property (nonatomic, copy) NSArray<NSURL *> *images;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, assign) BOOL isAllowApply;
@property (nonatomic, copy) NSURL *applyURL;
@property (nonatomic, copy) NSString *shareURLString;
@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) PageShowType departmentType;
@property (nonatomic, copy) NSURL *departmentURL;
@property (nonatomic, copy) NSArray<DepartmentModel *> *departments;

@end
