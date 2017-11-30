//
//  SearchViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "SpecialColumnModel.h"
#import "ClubViewModel.h"
@interface SearchViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSArray<ClubViewModel *> *clubViewModels;
@property (nonatomic, copy) SpecialColumnModel *specialColumnModel;
- (instancetype)init;
@end
