//
//  LKMessageManager.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKMessage.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>
extern NSString * const LKMessageCountKeyTotal;
@interface LKMessageManager : NSObject
@property (nonatomic, assign) NSInteger unreadMessageCount;
//@property (nonatomic, copy) NSDictionary *messageCountDict;
@property (nonatomic, copy, readonly) NSArray<Class> *allMessageTypes;
+ (instancetype)sharedInstance;
- (void)registerMessageClass:(Class<LKMessage>)messageClass;
- (Class)classForType:(NSString *)type;
- (void)configTableViewRegisters:(UITableView *)tableView;

@end
