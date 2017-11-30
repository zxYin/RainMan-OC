//
//  LKLibraryModule.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLibraryModule.h"
#import "LibrarySection.h"
#import "LibraryViewController.h"
#import "LibraryLoginViewController.h"
@implementation LKLibraryService
AUTH_REQUIRE(@"LKLibrary_libraryViewController",@"LKLibrary_presentLibraryLoginViewController")

- (BOOL)isEnable {
    return YES;
}

- (UIViewController *)LKLibrary_libraryViewController:(NSDictionary *)params {
    return [[LibraryViewController alloc] init];
}

- (YLTableViewSection *)LKLibrary_librarySection:(NSDictionary *)params {
    return [[LibrarySection alloc] init];
}

- (id)LKLibrary_presentLibraryLoginViewController:(NSDictionary *)params {
    LibraryLoginViewController *loginViewController =
    [[LibraryLoginViewController alloc] initWithCallback:params[@"callback"]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navController animated:YES completion:nil];
    return nil;
}
@end
