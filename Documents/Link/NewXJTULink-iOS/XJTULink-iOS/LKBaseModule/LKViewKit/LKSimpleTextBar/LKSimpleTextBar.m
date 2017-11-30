//
//  LKSimpleTextBar.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSimpleTextBar.h"

@interface LKSimpleTextBar()
@property (nonatomic, copy) void (^block)();

@end
@implementation LKSimpleTextBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}


+ (instancetype)simpleTextBarWithBlock:(void (^)())block {
    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"LKSimpleTextBar" owner:nil options:nil];
    LKSimpleTextBar *view = [views firstObject];
    view.block = block;
    return [views firstObject];
}


@end
