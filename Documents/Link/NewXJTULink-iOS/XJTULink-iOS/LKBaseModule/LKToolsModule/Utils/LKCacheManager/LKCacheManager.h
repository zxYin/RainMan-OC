//
//  LKCacheManager.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface LKCacheManager : NSObject
+ (void)clearAllWithCompletion:(void (^)())completion;
+ (void)clearCacheWithCompletion:(void (^)())completion;
+ (void)calculateCacheSizeWithCompletion:(void (^)(CGFloat size))completion;
@end
