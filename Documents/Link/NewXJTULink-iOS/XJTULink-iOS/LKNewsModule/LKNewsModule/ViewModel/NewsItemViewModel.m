//
//  NewsViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/17.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NewsItemViewModel.h"
#import "LKNetworking.h"
#import "Foundation+LKTools.h"
@implementation NewsItemViewModel

- (instancetype)initWithModel:(NewsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        
        RAC(self, pageTitle) = RACObserve(model, pageTitle);
        
        RAC(self, title) = RACObserve(model, title);
        RAC(self, date) = [RACObserve(model, date) map:^id(NSString *date) {
            NSString *result;
            if ([date length] >= 5) {
                result = [date substringFromIndex:5];
            } else {
                result = date;
            }
            return result;
        }];
        
        
        RAC(self, url) = [RACObserve(model, urlString) map:^id(NSString *url) {
//            return [NSURL URLWithString:@"http://192.168.199.177:8080"];
            return [NSURL URLWithString:[url stringByURLEncoding] ?:nil];
        }];
        RAC(self, originURL) = [RACObserve(model, originURLString) map:^id(NSString *url) {
            return [NSURL URLWithString:[url stringByURLEncoding]?:nil];
        }];
        
        RAC(self, newsId) = RACObserve(model, newsId);
        RAC(self, hasAccessory) = RACObserve(model, hasAccessory);
    }
    return self;
}

@end
