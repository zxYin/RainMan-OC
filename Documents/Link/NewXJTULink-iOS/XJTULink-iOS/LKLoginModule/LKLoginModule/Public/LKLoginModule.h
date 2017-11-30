//
//  LKLoginModule.h
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"

@interface LKLoginModule : NSObject

@end
@interface LKLoginService : LKService
- (id)LKLogin_casLoginAPIManager:(NSDictionary *)params;
- (id)LKLogin_logoutAPIManager:(NSDictionary *)params;
- (id)LKLogin_presentLoginViewController:(NSDictionary *)params;
@end
