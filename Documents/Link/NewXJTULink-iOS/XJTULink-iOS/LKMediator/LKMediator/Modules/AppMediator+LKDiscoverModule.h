//
//  AppMediator+LKDiscoverModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"

@interface AppMediator (LKDiscoverModule)
- (UIViewController *)LKDiscover_clubViewControllerWithClubId:(NSString *)clubId;
- (UIViewController *)LKDiscover_postDetailViewControllerWithPostId:(NSString *)postId;
@end
