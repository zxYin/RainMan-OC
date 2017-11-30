//
//  EvalutionStarRateCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "EvalutionStarRateCell.h"

@interface EvalutionStarRateCell()<CWStarRateViewDelegate>
@property (nonatomic, assign) NSInteger rate;
@end

@implementation EvalutionStarRateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starRateView.delegate = self;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    if(newScorePercent < 0) newScorePercent = 0;
    else if (newScorePercent > 1) newScorePercent = 1;
    NSInteger rate = (NSInteger)(newScorePercent * 5);
    if(rate < 1) rate = 1;
    else if(rate > 5) rate = 5;
    self.rate = rate;
}

@end
