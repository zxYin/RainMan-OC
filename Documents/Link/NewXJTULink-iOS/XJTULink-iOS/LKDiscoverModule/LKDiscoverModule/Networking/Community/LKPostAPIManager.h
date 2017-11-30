//
//  ConfessionAPIManager.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"

extern NSString * const kPostAPIManagerParamsKeyId;

extern NSString * const kPostAPIManagerParamsKeyContent;
extern NSString * const kPostAPIManagerParamsKeyReferName;
extern NSString * const kPostAPIManagerParamsKeyReferAcademy;
extern NSString * const kPostAPIManagerParamsKeyReferClass;

extern NSString * const kPostAPIManagerParamsKeyCommunityId;
extern NSString * const kPostAPIManagerParamsKeyOptionId;

typedef NS_ENUM(NSInteger, LKPostAPIManagerType) {
    LKPostAPIManagerTypeGet,
    LKPostAPIManagerTypeView,
    LKPostAPIManagerTypeSubmit,
    LKPostAPIManagerTypeDelete,
    LKPostAPIManagerTypeAccept,
    LKPostAPIManagerTypeRefer,
};

@interface LKPostAPIManager : YLBaseAPIManager<YLAPIManager>
+ (instancetype)apiManagerByType:(LKPostAPIManagerType)type;
@end
