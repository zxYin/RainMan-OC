//
//  YLBaseAPIManager+LKStatistics.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager+LKStatistics.h"
#import "UMMobClick/MobClick.h"


@implementation YLBaseAPIManager (LKStatistics)
//+ (void)load {
//    [NSObject methodSwizzlingWithTarget:@selector(afterLoadRequestWithParams:)
//                                  using:@selector(swizzling_LKStatistics_afterLoadRequestWithParams:)
//                               forClass:[self class]];
//    
//    [NSObject methodSwizzlingWithTarget:@selector(afterPerformSuccessWithResponseModel:)
//                                  using:@selector(swizzling_LKStatistics_afterPerformSuccessWithResponseModel:)
//                               forClass:[self class]];
//    
//    [NSObject methodSwizzlingWithTarget:@selector(afterPerformFailWithResponseError:)
//                                  using:@selector(swizzling_LKStatistics_afterPerformFailWithResponseError:)
//                               forClass:[self class]];
//    
//    [NSObject methodSwizzlingWithTarget:@selector(afterPerformCancel)
//                                  using:@selector(swizzling_LKStatistics_afterPerformCancel)
//                               forClass:[self class]];
//}

- (void)swizzling_LKStatistics_afterPerformCancel {
    [self swizzling_LKStatistics_afterPerformCancel];
    NSString *log = [NSString stringWithFormat:@"[Cancel][%@][%f][%@]",
                     NSStringFromClass([self class]),[NSDate timeIntervalSinceReferenceDate],((id<YLAPIManager>)self).path];
    [MobClick endEvent:@"request_event" label:log];
}

- (void)swizzling_LKStatistics_afterLoadRequestWithParams:(NSDictionary *)params {
    [self swizzling_LKStatistics_afterLoadRequestWithParams:params];
    
    NSString *log = [NSString stringWithFormat:@"[Start][%@][%f][%@][%@]",
                     NSStringFromClass([self class]),[NSDate timeIntervalSinceReferenceDate], params,((id<YLAPIManager>)self).path];
    
    [MobClick beginEvent:@"request_event" label:log];
}

- (void)swizzling_LKStatistics_afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    NSString *log = [NSString stringWithFormat:@"[Success][%@][%f][%@][%@]",
                     NSStringFromClass([self class]),[NSDate timeIntervalSinceReferenceDate], responseModel,((id<YLAPIManager>)self).path];
    
    [MobClick endEvent:@"request_event" label:log];
}

- (void)swizzling_LKStatistics_afterPerformFailWithResponseError:(YLResponseError *)error {
    NSString *log = [NSString stringWithFormat:@"[Fail][%@][%f][%@][%@]",
                     NSStringFromClass([self class]),[NSDate timeIntervalSinceReferenceDate], error, ((id<YLAPIManager>)self).path];
    
    [MobClick endEvent:@"request_event" label:log];
}

@end
