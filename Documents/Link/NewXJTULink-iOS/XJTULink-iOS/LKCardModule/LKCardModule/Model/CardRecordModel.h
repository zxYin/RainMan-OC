//
//  CardRecordModel.h
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, LKRefreshType) {
    LKRefreshTypeDefault = 0,
    LKRefreshTypeIncrement,
    LKRefreshTypeDecrement,
};

typedef struct LKRefreshMode {
    LKRefreshType type;
    NSInteger index;//需要刷新的行数，仅在mode非0时有用
}RefreshMode;

RefreshMode LKCardRefreshModeMake(LKRefreshType type,NSInteger index);


@interface CardRecordModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *weekday;
- (instancetype)initWithModel:(CardRecordModel *)model;
@end

typedef CardRecordModel CardRecordViewModel;
