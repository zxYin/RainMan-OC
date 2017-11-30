//
//  Foundation+LKFlowExtension.h
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (LKFlowExtension)
+ (CGFloat)calculateFlowCountWithInFlow:(NSString *)inFlow outFlow:(NSString *)outFlow;
@end
