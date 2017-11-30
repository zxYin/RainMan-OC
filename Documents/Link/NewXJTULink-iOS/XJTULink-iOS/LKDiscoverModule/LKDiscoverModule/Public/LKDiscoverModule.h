//
//  DiscoverModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <LKBaseModule/LKService.h>

@interface LKDiscoverModule : NSObject

@end

@interface LKDiscoverService : LKService
- (UIViewController *)LKDiscover_discoverViewController:(NSDictionary *)params;
- (UIViewController *)LKDiscover_clubViewController:(NSDictionary *)params;
- (UIViewController *)LKDiscover_confessionDetailViewController:(NSDictionary *)params;
- (UIViewController *)LKDiscover_postDetailViewController:(NSDictionary *)params;
@end
