//
//  SearchResultModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClubModel.h"
#import "SingleURLModel.h"

@interface SearchResultModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSArray<SingleURLModel *> *articleModels;
@property (nonatomic, copy) NSArray<ClubModel *> *clubModels;
@end
