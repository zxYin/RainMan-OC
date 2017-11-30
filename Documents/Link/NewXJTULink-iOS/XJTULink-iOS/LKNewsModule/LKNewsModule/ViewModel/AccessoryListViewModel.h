//
//  AccessoryListViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessoryModel.h"
#import "LKNetworking.h"
@interface AccessoryListViewModel : NSObject<YLNetworkingRACProtocol>
@property (strong,nonatomic) NSMutableDictionary *downloadedFiles;
@property (nonatomic, copy, readonly) NSArray<AccessoryModel *> *accessoryModels;
- (instancetype)initWithNewsId:(NSString *)newsId;

- (BOOL)fileExistsByName:(NSString *)name;
@end
