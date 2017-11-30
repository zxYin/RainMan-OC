//
//  LibraryViewModel.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibBookViewModel.h"
#import "LKNetworking.h"
@interface LibraryViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy) NSString *fine;

@property (nonatomic, strong) NSArray<LibBookViewModel *> *libBookViewModels;
@end
