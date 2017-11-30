//
//  LKNewsModule.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
#import "YLTableView.h"
@interface LKNewsModule : NSObject

@end

@interface LKNewsService : LKService
- (UIViewController *)LKNews_newsBrowser:(NSDictionary *)params;
- (UIViewController *)LKNews_newsListViewController:(NSDictionary *)params;
- (YLTableViewSection *)LKNews_newsSection:(NSDictionary *)params;
@end
