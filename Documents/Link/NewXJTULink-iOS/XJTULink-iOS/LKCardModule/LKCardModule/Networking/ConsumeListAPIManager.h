//
//  ConsumeListAPIManager.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLPageAPIManager.h"
extern NSString * const kConsumeListAPIManagerParamsKeyFromDate;
extern NSString * const kConsumeListAPIManagerParamsKeyToDate;

typedef NS_ENUM(NSInteger, ConsumeType) {
    ConsumeTypeToday,
    ConsumeTypeCustom,
};

// 这是一个类族
@interface ConsumeListAPIManager : YLPageAPIManager<YLPageAPIManager>
+ (ConsumeListAPIManager *)apiManagerWithType:(ConsumeType)type;
@end
