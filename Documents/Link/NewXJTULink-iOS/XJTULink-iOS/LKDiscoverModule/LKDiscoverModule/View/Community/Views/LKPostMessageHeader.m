//
//  ConfessionNewsMessageHeader.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostMessageHeader.h"

@interface LKPostMessageHeader()

@end

@implementation LKPostMessageHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView.layer.cornerRadius = self.backgroundView.frame.size.height / 2.0;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.highlightColor = [self.backgroundView.backgroundColor colorWithAlphaComponent:0.6];
    
    self.messageCountLabel.userInteractionEnabled = NO;
}

+ (instancetype)headerView {
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"LKPostMessageHeader" owner:nil options:nil];
    return [nibViews firstObject];
}
@end
