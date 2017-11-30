//
//  TranscriptsItemViewModel.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TranscriptsItemViewModel.h"
#import "Foundation+LKTools.h"
#import <ReactiveCocoa.h>
@implementation TranscriptsItemViewModel
- (instancetype)initWithModel:(TranscriptsItemModel *)model {
    self = [super init];
    if (self) {
        RAC(self, title) = RACObserve(model, name);
        RAC(self, score) = RACObserve(model, score);
        RAC(self, pass) =
        [RACObserve(model, score) map:^id(NSString *value) {
            if (![value isPureNumandCharacters]) {
                return @(![value isEqualToString:@"不及格"]);
            }
            
            NSInteger passLine = 60;
            if ([model.name containsString:@"大学英语四级"]
                || [model.name containsString:@"大学英语六级"]
                ) {
                passLine = 425;
            }
            return @([value integerValue] >= passLine);
        }];

    }
    return self;
}
@end
