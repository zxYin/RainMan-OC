//
//  LibraryManager.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibBookModel.h"
#import "LKNetworking.h"
#import <Mantle/Mantle.h>

@interface LibraryManager : MTLModel <YLNetworkingRACProtocol>
@property (nonatomic, copy) NSString *fine;
@property (nonatomic, copy) NSArray<LibBookModel *> *libBookModels;

+ (instancetype)sharedInstance;
@end
