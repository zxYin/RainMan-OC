//
//  LKLikeManager.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kLKLikeItemTypeConfession;
extern NSString * const kLKLikeItemTypeConfessionComment;

@interface LKLikeManager : NSObject
+ (instancetype)sharedInstance;

- (void)likeItemId:(NSString *)itemId type:(NSString *)type isCancel:(BOOL)isCancel;
@end
