//
//  ConfessionCommentMosaicCell.m
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentMosaicCell.h"
#import "LKAvatarView.h"
#import "ReactiveCocoa.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LKCommentMosaicCell ()

@property (weak, nonatomic) IBOutlet LKAvatarView *avatarView;

@end

@implementation LKCommentMosaicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(LKCommentViewModel *viewModel) {
        @strongify(self);
        [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.user.avatarURL] placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
        self.avatarView.nameLabel.text = viewModel.user.nickname;
        self.avatarView.tagLabel.text = @"";
        self.avatarView.subtitleLabel.text = [NSString stringWithFormat:@"%@ %@",viewModel.time,viewModel.remark];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
