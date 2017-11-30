//
//  AppMediator.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Foundation+LKTools.h"

#define LKModule(path,module)   [[AppMediator sharedInstance] addRoute:path forModule:module];
#define LKRoute(path,action,module) [[AppMediator sharedInstance] addRoute:path \
                                                                 forAction:action \
                                                                  onModule:module];

extern NSString * const kAppMediatorFinishUsingBlock;

@interface AppMediator : NSObject
+ (instancetype)sharedInstance;

/**
 *  远程调用
 *  所有来自远程调用（含从Safari等其他应用跳转及来自服务器的调用）均使用此方法进行调用
 *
 *  参数保留字段
 *  s   ----  起始页面(四个Tab + 当前页)
 *
 *  @param url        跳转路径及参数
 *
 *  @return 
 */
- (BOOL)performActionWithURL:(NSURL *)url;


// 本地调用
- (id)performAction:(NSString *)action onModule:(NSString *)module params:(NSDictionary *)params;

- (BOOL)addRoute:(NSString *)route forModule:(NSString *)module;
- (BOOL)addRoute:(NSString *)route forAction:(NSString *)action onModule:(NSString *)module;
@end
