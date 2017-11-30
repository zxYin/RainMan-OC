//
//  NSUserDefaults+LKTools.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (LKTools)
- (void)switchBoolForKey:(NSString *)key;
- (BOOL)hasKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
@end
