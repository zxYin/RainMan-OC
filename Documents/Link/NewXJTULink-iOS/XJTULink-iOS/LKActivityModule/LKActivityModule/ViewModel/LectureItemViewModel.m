//
//  LectureItemViewModel.m
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureItemViewModel.h"
#import <ReactiveCocoa.h>
#import "Constants.h"
@implementation LectureItemViewModel
- (instancetype)initWithModel:(LectureModel *)model {
    self = [super init];
    if (self) {
        RAC(self, title) = RACObserve(model, title);
        RAC(self, time) = RACObserve(model, time);
        RAC(self, url) = [RACObserve(model, url) map:^id(NSString *url) {
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/1.0/%@",kServerURL, model.url]]?:nil;
        }];
        RAC(self, locale) = RACObserve(model, locale);

    }
    return self;
}

@end
