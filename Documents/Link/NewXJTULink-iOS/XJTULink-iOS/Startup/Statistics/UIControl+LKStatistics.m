//
//  UIControl+LKStatistics.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UIControl+LKStatistics.h"
#import "UMMobClick/MobClick.h"

@implementation UIControl (LKStatistics)
//+ (void)load {
//    [NSObject methodSwizzlingWithTarget:@selector(sendAction:to:forEvent:)
//                                  using:@selector(swizzling_LKStatistics_sendAction:to:forEvent:)
//                               forClass:[self class]];
//}

- (void)swizzling_LKStatistics_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self swizzling_LKStatistics_sendAction:action to:target forEvent:event];
    
    NSString *targetName = NSStringFromClass([target class]);
    NSString *actionName = NSStringFromSelector(action);
    
    NSLog(@"[LKStatistics-UIControl][%@][%@][%@]",targetName, actionName, event);
}
@end
