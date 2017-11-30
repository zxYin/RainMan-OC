//
//  SingleURLModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SingleURLModel.h"

@implementation SingleURLModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url":@"url",
             @"title":@"title",
             };
}
+ (SingleURLModel *)singleURLModelWithURL:(NSURL *)url title:(NSString *)title {
    SingleURLModel *model = [[SingleURLModel alloc] init];
    model.url = url;
    model.title = title;
    return model;
}
@end
