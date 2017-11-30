//
//  WeekFormatter.h
//  TestA
//
//  Created by Yunpeng on 2016/11/21.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
typedef NS_ENUM(NSInteger,WeekType) {
    WeekTypeCustom = 0,
    WeekTypeOdd,  // 奇数周
    WeekTypeEven, // 偶数周
};


@interface WeekFormatter : MTLModel

@property (nonatomic, copy, readonly) NSIndexSet *indexSet;
@property (nonatomic, copy, readonly) NSString *rawString;
@property (nonatomic, copy, readonly) NSString *groupedString;
@property (nonatomic, assign, readonly) WeekType type;

- (instancetype)initWithString:(NSString *)str;
+ (instancetype)formatterWithString:(NSString *)str;
@end
