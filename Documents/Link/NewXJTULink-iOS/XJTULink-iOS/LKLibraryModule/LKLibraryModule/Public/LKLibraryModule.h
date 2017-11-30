//
//  LKLibraryModule.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKService.h"
#import "YLTableView.h"
@interface LKLibraryModule : NSObject

@end


@interface LKLibraryService : LKService
- (YLTableViewSection *)LKLibrary_librarySection:(NSDictionary *)params;
- (UIViewController *)LKLibrary_libraryViewController:(NSDictionary *)params;
- (id)LKLibrary_presentLibraryLoginViewController:(NSDictionary *)params;
@end
