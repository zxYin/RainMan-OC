//
//  LKTextView+Draft.m
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "LKTextView+Draft.h"
@implementation LKTextView (Draft)
+ (void)clearDrafts {
    [[LKTextView draftManager] removeAllObjects];
}

+ (NSMutableDictionary *)draftManager {
    static NSMutableDictionary * draftManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 草稿暂时不需要持久化，退出App即清空
        draftManager = [NSMutableDictionary new];
    });
    return draftManager;
}

+ (void)setDraft:(NSString *)draft forId:(NSString *)itemId type:(NSString *)item {
    [self setDraft:draft forKey:LKTextViewDraftKey(item, itemId)];
}

+ (NSString *)draftForId:(NSString *)itemId type:(NSString *)item {
    return [self draftForKey:LKTextViewDraftKey(item, itemId)];
}

+ (void)setDraft:(NSString *)draft forKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]
        || ![draft isKindOfClass:[NSString class]]) {
        return;
    }
    [LKTextView draftManager][key] = draft;
}

+ (NSString *)draftForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    return [LKTextView draftManager][key];
}

+ (void)removeDraftForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    [LKTextView draftManager][key] = nil;
}


@end
