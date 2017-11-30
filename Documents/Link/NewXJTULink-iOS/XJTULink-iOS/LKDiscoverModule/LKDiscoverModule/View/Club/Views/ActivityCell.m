//
//  ActivityCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ActivityCell.h"
#import "ViewsConfig.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    self.contentLabel.preferredMaxLayoutWidth = WIDTH - 16;
    self.activityImageView.image = nil;
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(ActivityModel *viewModel) {
        @strongify(self);
        self.nameLabel.text = viewModel.name;
        self.honorLabel.text = viewModel.honor;
        [self.activityImageView sd_setImageWithURL:viewModel.imageURL];
        self.activityImageView.clipsToBounds = YES;
        [self sendSubviewToBack:self.activityImageView];
        self.contentLabel.text = viewModel.introduction;
    }];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
