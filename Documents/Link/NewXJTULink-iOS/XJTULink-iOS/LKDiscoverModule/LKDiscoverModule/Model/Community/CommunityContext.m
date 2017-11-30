//
//  ConfessionContext.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "CommunityContext.h"
#import <libkern/OSAtomic.h>
#import "Chameleon.h"
static CommunityContext *instance;
static OSSpinLock lk_confession_context_lock = OS_SPINLOCK_INIT;

@implementation ConfessionEditorContext
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"placeholder":@"placeholder",
             };
}

@end

@implementation CommunityOption
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"optionId":@"option_id",
             @"title":@"title",
             @"allowPost":@"allow_post",
             @"allowRefer":@"allow_refer_student",
             @"editorContext":@"editor",
             };
}

@end

@implementation CommunityContext
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"communityId":@"community_id",
             @"tintColor":@"tint_color",
             @"image":@"image",
             @"options":@"option_list"
             };
}

+ (NSValueTransformer *)tintColorJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [UIColor colorWithHexString:value];
    }];
}

+ (NSValueTransformer *)optionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CommunityOption class]];
}

+ (instancetype)currentContext {
    CommunityContext *result;
    OSSpinLockLock(&lk_confession_context_lock);
    result = instance;
    OSSpinLockUnlock(&lk_confession_context_lock);
    return result;
}
+ (void)setupCurrentContext:(CommunityContext *)context {
    OSSpinLockLock(&lk_confession_context_lock);
    instance = context;
    OSSpinLockUnlock(&lk_confession_context_lock);
}
@end
