//
//  LibBookViewModel.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibBookViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DateTools.h"
@interface LibBookViewModel()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@end

@implementation LibBookViewModel
- (instancetype)initWithModel:(LibBookModel *)model {
    self = [super init];
    if (self != nil) {
        RAC(self, title) = RACObserve(model, name);
        RAC(self, date) = RACObserve(model, date);
    }
    return self;
}

- (NSString *)countdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    NSInteger beginDays = 0;
    if (interval > 0) {
        beginDays =  ((NSInteger)interval)/(60 * 60 * 24) + 1;
    }
    return [@(beginDays) stringValue];
}


@end
