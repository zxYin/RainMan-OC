//
//  LKCarouselSection.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/12.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCarouselSection.h"
#import "LKNewsBrowser.h"

@implementation LKCarouselSection
#pragma mark - override
- (NSString *)title {
    return @"交大头条";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"DiscoverHeadlineCell":@"NewsItemViewModel"
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return nil;
}


@end
