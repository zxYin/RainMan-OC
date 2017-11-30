//
//  YLTableViewManager+ReactiveExtension.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLTableViewManager+ReactiveExtension.h"

@implementation YLTableViewManager (ReactiveExtension)
- (void)binding:(RACSignal *)signal forKey:(NSString *)key {
    @weakify(self);
    [[[signal skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self updateSectionByKey:key];
     }];
}
@end
