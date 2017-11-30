//
//  UITableView+LKStatistics.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UITableView+LKStatistics.h"

@interface UITableView (_LKStatistics)

@end

@implementation UITableView (LKStatistics)
//+ (void)load {
//    [NSObject methodSwizzlingWithTarget:@selector(setDelegate:)
//                                  using:@selector(swizzling_LKStatistics_setDelegate:)
//                               forClass:[self class]];
//}


- (void)swizzling_LKStatistics_setDelegate:(id<UITableViewDelegate>)delegate {
    [self swizzling_LKStatistics_setDelegate:delegate];
    
    [NSObject methodSwizzlingWithTarget:@selector(tableView:didSelectRowAtIndexPath:)
                                  using:@selector(swizzling_LKStatistics_tableView:didSelectRowAtIndexPath:)
                               forClass:[delegate class]];
}

- (void)swizzling_LKStatistics_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self swizzling_LKStatistics_tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSLog(@"[LKStatistics-UITableView][%@][%@]",tableView, indexPath);
}

@end
