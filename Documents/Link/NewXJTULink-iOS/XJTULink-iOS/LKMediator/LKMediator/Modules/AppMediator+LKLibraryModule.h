//
//  AppMediator+LKLibraryModule.h
//  LKMediator
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "YLTableView.h"
@interface AppMediator (LKLibraryModule)
- (YLTableViewSection *)LKLibrary_librarySection;
- (void)LKLibrary_libraryViewController:(void(^)(UIViewController *libraryViewController))block;
- (void)LKLibrary_presentLibraryLoginViewControllerWithSuccess:(void(^)())block;
@end
