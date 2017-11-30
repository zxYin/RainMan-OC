//
//  InteractionMessage.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/30.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "InteractionMessage.h"
#import "LKMessageManager.h"
#import "Macros.h"

@implementation InteractionMessage
+ (void)load {
    async_execute_after_launching(^{
        [[LKMessageManager sharedInstance] registerMessageClass:[InteractionMessage class]];
    });
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dict addEntriesFromDictionary:@{
         @"referContent":@"refer_content",
         @"operation":@"operation",
         @"allowReply":@"allow_reply",
         @"user":@"user",
         @"tintColor":@"tint_color",
         @"referName":@"refer_name",
    }];
    return [dict copy];
}


+ (NSString *)type {
    return @"interaction";
}

+ (NSString *)cellName {
    return @"InteractionMessageCell";
}

@end
