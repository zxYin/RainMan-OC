//
//  LKMessageTextCell.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageTextCell.h"
#import "NSDate+LKTools.h"
#import "UILabel+LKTextModel.h"
@implementation LKMessageTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    self.titleLabel.preferredMaxLayoutWidth = WIDTH - 28;
    self.contentLabel.preferredMaxLayoutWidth = WIDTH;
    self.timeLabel.preferredMaxLayoutWidth = WIDTH;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(LKMessage *)model {    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.timestamp];
    self.timeLabel.text = [date lk_timeString];
    [self.tagLabel lk_setTextWithModel:model.tag];
    self.sourceLabel.text = model.source;
    
}

@end
