//
//  AppMediator+LKDiscoverModule.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKDiscoverModule.h"
NSString * const kAppMediatorDiscoverModule= @"LKDiscoverModule";

NSString * const kAppMediatorDiscoverServiceClubViewController = @"clubViewController";
NSString * const kAppMediatorDiscoverServiceConfessionDetailViewController = @"confessionDetailViewController";
NSString * const kAppMediatorDiscoverServicePostDetailViewController = @"postDetailViewController";


@implementation AppMediator (LKDiscoverModule)
+ (void)load {
    LKModule(@"discover", kAppMediatorDiscoverModule);
    
    /**
     打开社团页面
     @param clubId      社团id
     */
    LKRoute(@"/club/", kAppMediatorDiscoverServiceClubViewController, kAppMediatorDiscoverModule);
    
    /**
     打开表白墙详情页面
     之后将会弃用这个接口
     @param confessionId      表白id
     */
    LKRoute(@"/confession/", kAppMediatorDiscoverServiceConfessionDetailViewController, kAppMediatorDiscoverModule);
    
    
//    /**
//     打开社区
//     @param communityId      社区id
//     @param optionId      optionId
//     */
//    LKRoute(@"/community/", kAppMediatorDiscoverServicePostDetailViewController, kAppMediatorDiscoverModule);
    
    /**
     打开贴子详情页面
     @param postId      贴子id
     */
    LKRoute(@"/community/post/", kAppMediatorDiscoverServicePostDetailViewController, kAppMediatorDiscoverModule);
}

- (UIViewController *)LKDiscover_clubViewControllerWithClubId:(NSString *)clubId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"clubId"] = clubId;
    return [[self performAction:kAppMediatorDiscoverServiceClubViewController
                       onModule:kAppMediatorDiscoverModule
                         params:[params copy]]
            safeType:[UIViewController class]];
}

- (UIViewController *)LKDiscover_postDetailViewControllerWithPostId:(NSString *)postId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"postId"] = postId;
    return [[self performAction:kAppMediatorDiscoverServiceConfessionDetailViewController
                       onModule:kAppMediatorDiscoverModule
                         params:[params copy]]
            safeType:[UIViewController class]];
}

@end
