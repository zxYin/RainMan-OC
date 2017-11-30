//
//  LKMessage.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessage.h"
#import "LKTextAlertView.h"
#import "LKWebBrowser.h"
#import "AppMediator.h"
#import "AppContext.h"
#import "Macros.h"
#import "NSDictionary+LKValueGetter.h"
#import "LKMessageManager.h"
@implementation LKMessage
+ (void)load {
    async_execute_after_launching(^{
        [[LKMessageManager sharedInstance] registerMessageClass:[LKMessage class]];
    });
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"messageId":@"id",
        @"source":@"source",
        @"title":@"title",
        @"content":@"content",
        @"command":@"command",
        @"timestamp":@"timestamp",
        @"tag":@"tag"
    };
}

+ (NSString *)type {
    return @"text";
}

+ (NSString *)cellName {
    return @"LKMessageTextCell";
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return [[LKMessageManager sharedInstance] classForType:[JSONDictionary stringForKey:@"type"]];
}

@end
