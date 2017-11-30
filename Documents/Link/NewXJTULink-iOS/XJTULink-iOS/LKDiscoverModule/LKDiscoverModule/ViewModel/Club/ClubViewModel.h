//
//  ClubViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "DepartmentsViewModel.h"
#import "ClubModel.h"
#import "LKShareModel.h"

@interface ClubViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSString *clubId;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *honor;
@property (nonatomic, assign) PageShowType showType;
@property (nonatomic, copy) NSURL *webURL;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, assign) BOOL isAllowApply;
@property (nonatomic, copy) NSURL *applyURL;
@property (nonatomic, copy) NSString *shareURLString;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, strong) DepartmentsViewModel *departmentsViewModel;
@property (nonatomic, copy, readonly) NSString *applyPageJS;

@property (nonatomic, strong, readonly) LKShareModel *shareModel;

- (instancetype)initWithClubId:(NSString *)clubId;
- (instancetype)initWithClubModel:(ClubModel *)model;
@end
