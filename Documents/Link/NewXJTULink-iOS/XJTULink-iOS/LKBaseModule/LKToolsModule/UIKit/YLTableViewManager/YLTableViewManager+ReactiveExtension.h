//
//  YLTableViewManager+ReactiveExtension.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLTableViewManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface YLTableViewManager (ReactiveExtension)
- (void)binding:(RACSignal *)signal forKey:(NSString *)key;
@end
