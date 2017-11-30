//
//  LibraryAPIManager.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"
extern NSString * const kLibraryAPIManagerParamsKeyLibUsername;
extern NSString * const kLibraryAPIManagerParamsKeyLibPassword;

@interface LibraryAPIManager : YLBaseAPIManager<YLAPIManager>
@end
