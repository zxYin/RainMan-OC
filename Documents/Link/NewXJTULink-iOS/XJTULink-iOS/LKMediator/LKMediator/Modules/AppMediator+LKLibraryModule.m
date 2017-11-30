//
//  AppMediator+LKLibraryModule.m
//  LKMediator
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKLibraryModule.h"
#import "User+Auth.h"

NSString * const kAppMediatorLibraryModule = @"LKLibraryModule";
NSString * const kAppMediatorLibraryServicePresentLibraryLoginViewController = @"presentLibraryLoginViewController";
NSString * const kAppMediatorLibraryServiceLibraryViewController = @"libraryViewController";
NSString * const kAppMediatorLibraryServiceLibSection = @"librarySection";

@implementation AppMediator (LKLibraryModule)
+ (void)load {
    LKModule(@"library", kAppMediatorLibraryModule);
    LKRoute(@"/", kAppMediatorLibraryServiceLibraryViewController, kAppMediatorLibraryModule);
}


- (YLTableViewSection *)LKLibrary_librarySection {
    return [[self performAction:kAppMediatorLibraryServiceLibSection
                       onModule:kAppMediatorLibraryModule
                         params:nil]
            safeType:[YLTableViewSection class]];
}

- (void)LKLibrary_libraryViewController:(void(^)(UIViewController *libraryViewController))block {
    if (block) {
        if ([User sharedInstance].libUsername == nil) {
            [self LKLibrary_presentLibraryLoginViewControllerWithSuccess:^{
                [[self performAction:kAppMediatorLibraryServiceLibraryViewController
                            onModule:kAppMediatorLibraryModule
                              params:@{kAppMediatorFinishUsingBlock : [block copy]}]
                 safeType:[UIViewController class]];
            }];
        } else {
            [[self performAction:kAppMediatorLibraryServiceLibraryViewController
                        onModule:kAppMediatorLibraryModule
                          params:@{kAppMediatorFinishUsingBlock : [block copy]}]
             safeType:[UIViewController class]];
        }
    }
}

- (void)LKLibrary_presentLibraryLoginViewControllerWithSuccess:(void(^)())block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"callback"] = [block copy];
    [self performAction:kAppMediatorLibraryServicePresentLibraryLoginViewController
               onModule:kAppMediatorLibraryModule
                 params:[params copy]];
    
}
@end
