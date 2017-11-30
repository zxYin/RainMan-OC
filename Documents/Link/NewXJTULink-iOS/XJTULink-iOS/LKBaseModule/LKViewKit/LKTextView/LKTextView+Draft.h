//
//  LKTextView+Draft.h
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "LKTextView.h"
#define LKTextViewDraftKey(ITEM, ID) [NSString stringWithFormat:@"%@_%@",ITEM, ID]
@interface LKTextView (Draft)
+ (void)clearDrafts;
+ (void)setDraft:(NSString *)draft forId:(NSString *)itemId type:(NSString *)item;
+ (NSString *)draftForId:(NSString *)itemId type:(NSString *)item;


+ (void)setDraft:(NSString *)draft forKey:(NSString *)key;
+ (NSString *)draftForKey:(NSString *)key;
+ (void)removeDraftForKey:(NSString *)key;
@end
