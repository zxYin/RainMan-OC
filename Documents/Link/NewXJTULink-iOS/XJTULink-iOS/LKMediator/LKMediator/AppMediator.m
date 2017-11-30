//
//  AppMediator.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/5.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "LKService.h"
#import <objc/runtime.h>
#import "AppMediator+LKLoginModule.h"
#import "User.h"
#import "Constants.h"
#import "AppContext.h"
#import "LKNotFoundViewController.h"
#import "Foundation+LKTools.h"

NSString * const kAppMediatorFinishUsingBlock = @"kAppMediatorFinishUsingBlock";

NSString * const kAppMediatorRouteTableKeyModule = @"module";
NSString * const kAppMediatorRouteTableKeyAction = @"action";
NSString * const kAppMediatorRouteTableKeyParams = @"params";

@interface AppMediator()
@property (nonatomic, strong) NSMutableDictionary *nativeModuleRouteTable;
@property (nonatomic, strong) NSMutableDictionary *nativeActionRouteTable;

@property (nonatomic, copy) NSDictionary *hotRouteTable;
@end

@implementation AppMediator
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppMediator *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppMediator alloc] init];
    });
    return instance;
}

- (BOOL)performActionWithURL:(NSURL *)url {
    if(![[url.scheme lowercaseString] isEqualToString:AppScheme]) {
        if ([url.absoluteString containsString:@"itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:url];
            return YES;
        }
        return NO;
    }
    
    NSString *moduleKey = url.host;
    NSString *actionKey = [NSString isBlank:url.path]?@"/":url.path;
    
    if ([actionKey characterAtIndex:actionKey.length-1] != '/') {
        actionKey = [actionKey stringByAppendingString:@"/"];
    }
    
    NSDictionary *qurtyDict = [NSDictionary dictionaryWithURLQueryString:url.query];
    NSString *tabBarItemString = [qurtyDict stringForKey:@"s"];

    NSString *module = self.nativeModuleRouteTable[moduleKey];
    NSString *action = self.nativeActionRouteTable[module][actionKey];
    
    if (action == nil) {
        LKTabBarItem tabBarItem = [AppContext tabBarItemByString:tabBarItemString];
        [[AppContext sharedInstance] navigationControllerOfTabBarControllerAtItem:tabBarItem];
        return NO;
    }
    
    NSLog(@"远程调用: module:%@, action:%@, tabbar:%@",moduleKey, actionKey, tabBarItemString);
    NSLog(@"实际调用: module:%@, action:%@, tabbar:%@",module, action, tabBarItemString);
    
    void (^block)(id x) = ^(id result) {
        NSLog(@"获取完毕:%@",result);
        if (![result isKindOfClass:[UIViewController class]]) {
            return;
        }
        
        UIViewController *vc = result;
        LKTabBarItem tabBarItem = [AppContext tabBarItemByString:tabBarItemString];
        UINavigationController *navController = [[AppContext sharedInstance] navigationControllerOfTabBarControllerAtItem:tabBarItem];
        
        vc.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:vc animated:YES];
        NSLog(@"跳转完毕");
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{kAppMediatorFinishUsingBlock:[block copy]}];
    [params addEntriesFromDictionary:qurtyDict];
    
    [self performAction:action
               onModule:module
                 params:[params copy]];
    
    return YES;
}


// 本地调用
- (id)performAction:(NSString *)actionName
           onModule:(NSString *)moduleName
             params:(NSDictionary *)params {
    
    NSString *serviceName = moduleName;
    if ([moduleName hasSuffix:@"Module"]) {
        serviceName = [moduleName substringToIndex:moduleName.length - 6];
    }
    
    // 服务器下发配置文件从而动态改变路由
    NSDictionary *route = self.hotRouteTable[[NSString stringWithFormat:@"%@_%@", serviceName, actionName]];
    if (route != nil) {
        NSString *newModule = [route stringForKey:kAppMediatorRouteTableKeyModule];
        NSString *newAction = [route stringForKey:kAppMediatorRouteTableKeyAction];
        NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
        [newParams addEntriesFromDictionary:params];
        [newParams addEntriesFromDictionary:route[kAppMediatorRouteTableKeyParams]];
        return [self performAction:newAction onModule:newModule params:newParams];
    }
    
    NSString *actionString = [NSString stringWithFormat:@"%@_%@:", serviceName, actionName];
    NSLog(@"[AppMediator]调用%@ - %@", serviceName, actionString);
    
    LKService *serviceProvider = LKServiceFromString(serviceName);;
    SEL action = NSSelectorFromString(actionString);
    NSLog(@"[AppMediator]%@",serviceProvider);
    if (serviceProvider == nil) {
        // 这里是处理无响应请求的地方之一，如果没有可以响应的target，就直接return了。
        // 可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return [LKNotFoundViewController new];
    }
    
    void(^callback)(id obj) = params[kAppMediatorFinishUsingBlock];
    if ([serviceProvider respondsToSelector:action]) {
        
        if ([serviceProvider respondsToSelector:@selector(shouldLoginBeforeAction:)]
             && [serviceProvider shouldLoginBeforeAction:actionName]
             && ![User isLogined]
            ) {
            /**
             *  这里是AOP检测登录情况，若要求登录态且用户尚未登录则弹出登录框
             */
                [self LKLogin_presentLoginViewControllerWithSuccess:^(){
#ifdef DEBUG
                    // debug模式下不判断callback，若callback为nil则会强制挂掉，方便查错
                    callback([serviceProvider performSelector:action withObject:params]);
#else
                    // release 模式下尽可能安全
                    if(callback) {
                        callback([serviceProvider performSelector:action withObject:params]);
                    }
#endif
                } animation:YES];
            return nil;
        }
        
        id result = [serviceProvider performSelector:action withObject:params];
        if (callback) {
            callback(result);
            return nil;
        } else {
            return result;
        }
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([serviceProvider respondsToSelector:action]) {
            return [serviceProvider performSelector:action withObject:params];
        } else {
            // 这里也是处理无响应请求的地方
            return [LKNotFoundViewController new];
        }
    }
}

#define LKServiceFromModule(x) [NSString stringWithString:x]

- (id)p2erformAction:(NSString *)actionName
           onModule:(NSString *)moduleName
             params:(NSDictionary *)params {
    
    NSString *serviceName = LKServiceFromModule(moduleName);
    
    // 服务器下发配置文件从而动态改变路由
    NSDictionary *route = self.hotRouteTable[[NSString stringWithFormat:@"%@_%@", serviceName, actionName]];
    if (route != nil) {
        NSString *newModule = [route stringForKey:kAppMediatorRouteTableKeyModule];
        NSString *newAction = [route stringForKey:kAppMediatorRouteTableKeyAction];
        NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
        [newParams addEntriesFromDictionary:params];
        [newParams addEntriesFromDictionary:route[kAppMediatorRouteTableKeyParams]];
        return [self performAction:newAction onModule:newModule params:newParams];
    }
    
    NSString *actionString = [NSString stringWithFormat:@"%@_%@:", serviceName, actionName];
    LKService *serviceProvider = LKServiceFromString(serviceName);;
    SEL action = NSSelectorFromString(actionString);
    if (serviceProvider == nil) return nil;
    
    void(^callback)(id obj) = params[kAppMediatorFinishUsingBlock];
    if ([serviceProvider respondsToSelector:action]) {
        
        if ([serviceProvider respondsToSelector:@selector(shouldLoginBeforeAction:)]
            && [serviceProvider shouldLoginBeforeAction:actionName]
            && ![User isLogined]
            ) {
            // 这里是AOP检测登录情况，若要求登录态且用户尚未登录则弹出登录框
            [self LKLogin_presentLoginViewControllerWithSuccess:^(){
                if(callback) {
                    callback([serviceProvider performSelector:action withObject:params]);
                }
            } animation:YES];
            return nil;
        }
        
        id result = [serviceProvider performSelector:action withObject:params];
        if (callback) {
            callback(result);
            return nil;
        } else {
            return result;
        }
    } else {
        return nil;
    }
}



- (BOOL)addRoute:(NSString *)route forModule:(NSString *)module {
    if ([NSString isBlank:route]
        || [NSString isBlank:module]) {
        return NO;
    }
    self.nativeModuleRouteTable[route] = module;
    return YES;
}
- (BOOL)addRoute:(NSString *)route forAction:(NSString *)action onModule:(NSString *)module {
    if ([NSString isBlank:route]
        || [NSString isBlank:module]) {
        return NO;
    }
    
    NSMutableDictionary *subRouteTable = self.nativeActionRouteTable[module];
    if (subRouteTable == nil) {
        self.nativeActionRouteTable[module] =
        [[NSMutableDictionary alloc] initWithDictionary:@{
                                                          route:action
                                                         }];
    } else {
        subRouteTable[route] = action;
    }
    return YES;
}


- (NSMutableDictionary *)nativeModuleRouteTable {
    if (_nativeModuleRouteTable == nil) {
        _nativeModuleRouteTable = [[NSMutableDictionary alloc] init];
    }
    return _nativeModuleRouteTable;
}

- (NSMutableDictionary *)nativeActionRouteTable {
    if (_nativeActionRouteTable == nil) {
        _nativeActionRouteTable = [[NSMutableDictionary alloc] init];
    }
    return _nativeActionRouteTable;
}

#pragma clang diagnostic pop
@end
