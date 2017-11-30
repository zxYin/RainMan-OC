//
//  LikeAPIManager.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKNetworking.h"

@interface LikeAPIManager : YLBaseAPIManager<YLAPIManager>
@property (nonatomic, copy) NSDictionary *item;
@end
