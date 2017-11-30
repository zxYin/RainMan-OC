//
//  ShareModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKShareModel.h"

@implementation LKShareModel
- (instancetype)initWithURL:(NSString *)url title:(NSString *)title summary:(NSString *)summary image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.url = url;
        self.title = title;
        self.summary = summary;
        self.image = image;
    }
    return self;
}

+ (instancetype)modelWithURL:(NSString *)url title:(NSString *)title summary:(NSString *)summary image:(UIImage *)image {
    return [[LKShareModel alloc]initWithURL:url title:title summary:summary image:image];
}

@end
