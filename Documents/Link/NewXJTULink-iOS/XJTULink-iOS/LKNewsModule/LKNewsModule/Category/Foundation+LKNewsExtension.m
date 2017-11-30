//
//  Foundation+LKNewsExtension.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "Foundation+LKNewsExtension.h"

@implementation NSDictionary (LKNewsExtension)
- (NewsItemViewModel *)newsItemViewModelForKey:(NSString *)key {
    NewsItemViewModel *viewModel = nil;
    id news = [self objectForKey:key];
    if ([news isKindOfClass:[NewsItemViewModel class]]) {
        viewModel = news;
    } else if([news isKindOfClass:[NewsModel class]]) {
        viewModel = [[NewsItemViewModel alloc] initWithModel:news];
    }
    return viewModel;
}

- (NewsModel *)newsModelForKey:(NSString *)key {
    NewsModel *model = nil;
    id news = [self objectForKey:key];
    if ([news isKindOfClass:[NewsModel class]]) {
        model = news;
    }
    return model;
}
@end
