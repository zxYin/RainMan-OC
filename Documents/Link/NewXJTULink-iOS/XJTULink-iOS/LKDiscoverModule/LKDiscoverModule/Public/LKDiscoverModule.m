//
//  DiscoverModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKDiscoverModule.h"
#import "DiscoverViewController.h"
#import "ClubViewController.h"
#import "NSDictionary+LKValueGetter.h"
#import "Foundation+LKTools.h"
#import "LKPostDetailViewContoller.h"
@implementation LKDiscoverModule

@end

@implementation LKDiscoverService
- (UIViewController *)LKDiscover_discoverViewController:(NSDictionary *)params {
    return [[DiscoverViewController alloc] init];
}

- (UIViewController *)LKDiscover_clubViewController:(NSDictionary *)params {
    NSString *clubId = [params stringForKey:@"clubId"];
    if ([NSString isBlank:clubId]) {
        return nil;
    }
    ClubViewModel *viewModel = [[ClubViewModel alloc] initWithClubId:clubId];
    ClubViewController *vc = [[ClubViewController alloc] initWithViewModel:viewModel];
    return vc;
}

// 兼容当前表白墙
- (UIViewController *)LKDiscover_confessionDetailViewController:(NSDictionary *)params {
    NSMutableDictionary *paramsDict = [params mutableCopy];
    paramsDict[@"postId"] = [params stringForKey:@"confessionId"];
    paramsDict[@"confessionId"] = nil;
    return [self LKDiscover_postDetailViewController:[paramsDict copy]];
}

- (UIViewController *)LKDiscover_postDetailViewController:(NSDictionary *)params {
    NSString *postId = [params stringForKey:@"postId"];
    if ([NSString isBlank:postId]) {
        return nil;
    }
    LKPostViewModel *viewModel = [[LKPostViewModel alloc] initWithPostId:postId];
    LKPostDetailViewContoller *vc = [[LKPostDetailViewContoller alloc] initWithViewModel:viewModel];
    return vc;
}
@end



