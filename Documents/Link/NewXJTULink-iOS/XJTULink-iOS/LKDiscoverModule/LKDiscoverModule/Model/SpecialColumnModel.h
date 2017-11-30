//
//  SpecialColumnModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleURLModel.h"
#import <Mantle/Mantle.h>
@interface SpecialColumnModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<SingleURLModel *> *items;
@end
