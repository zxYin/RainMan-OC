//
//  Foundation+LKFlowExtension.m
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "Foundation+LKFlowExtension.h"

typedef NS_ENUM(NSUInteger,Flow){
    FlowCount = 0,
    FlowUnit = 1,
};

@implementation NSString (LKFlowExtension)
+ (CGFloat) calculateFlowCountWithInFlow:(NSString *)inFlow outFlow:(NSString *)outFlow {
    CGFloat inf = 0.0;
    CGFloat outf = 0.0;
    NSArray *inFlowArray = [inFlow componentsSeparatedByString:@" "];
    NSArray *outFlowArray = [outFlow componentsSeparatedByString:@" "];
    if (inFlowArray.count == 2 && outFlowArray.count == 2) {
        inf = [inFlowArray[FlowCount] doubleValue];
        outf = [outFlowArray[FlowCount] doubleValue];
        if ([inFlowArray[FlowUnit] isEqualToString:@"MB"]) {
            inf /= 1024.0;
        }
        if ([outFlowArray[FlowUnit] isEqualToString:@"MB"]) {
            outf /= 1024.0;
        }
        
        if ([inFlowArray[FlowUnit] isEqualToString:@"KB"]) {
            inf /= 1024.0 * 1024.0;
        }
        if ([outFlowArray[FlowUnit] isEqualToString:@"KB"]) {
            outf /= 1024.0 * 1024.0;
        }
    }
    return inf+outf;
}
@end
