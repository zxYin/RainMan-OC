//
//  ConfessionWithAvatarCell.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostCell.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "UIImageView+LKTools.h"
#import "UILabel+LKTextModel.h"
#import "UIView+YLAutoLayoutHider.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface LKPostCell()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UILabel *deleteLabel;
@end
@implementation LKPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.likeCountLabel.userInteractionEnabled = NO;
    
    
    CGFloat WIDTH = self.frame.size.width;
    self.contentLabel.preferredMaxLayoutWidth = WIDTH - 22;
    self.commentCountLabel.preferredMaxLayoutWidth = WIDTH;
    self.blurry = NO;
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(LKPostViewModel *viewModel) {
        @strongify(self);
        
        if ([NSString notBlank:viewModel.referStudent]) {
            [self.targetLabel yl_setHidden:NO forType:YLHiddenTypeVertical];
            self.targetLabel.text = [NSString stringWithFormat:@"提到了 %@",viewModel.referStudent];
        } else {
            [self.targetLabel yl_setHidden:YES forType:YLHiddenTypeVertical];
        }
        if ([NSString notBlank:viewModel.content]) {
            NSMutableAttributedString *attrContent =
            [[NSMutableAttributedString alloc] initWithString:viewModel.content];
            NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setLineSpacing:5];
            [attrContent addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, [attrContent length])];
            self.contentLabel.attributedText = attrContent;
        } else {
            self.contentLabel.text = @"";
        }
        
        self.hotImageView.hidden = !viewModel.isHot;
        
        [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.user.avatarURL] placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
        [self.avatarView.tagLabel lk_setTextWithModel:self.viewModel.user.tag];
        self.avatarView.subtitleLabel.text = viewModel.time;
        self.avatarView.nameLabel.text = viewModel.user.nickname;
        
        RAC(self.likeCountLabel, text) = [RACObserve(viewModel, likeCount) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.commentCountLabel, text) = [RACObserve(viewModel, commentCount) takeUntil:self.rac_prepareForReuseSignal];
        
        [self.tagLabel lk_setTextWithModel:viewModel.tag];
        
        RAC(self, blurry) = [RACObserve(viewModel, isDeleted) takeUntil:self.rac_prepareForReuseSignal];
        
        [[RACObserve(viewModel, liked) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *liked) {
            if ([liked boolValue]) {
                [self.likeButton setImage:[UIImage imageNamed:@"wall_like_highlight"] forState:UIControlStateNormal];
            } else {
                [self.likeButton setImage:[UIImage imageNamed:@"wall_like_normal"] forState:UIControlStateNormal];
            }
        }];
        
        
        if (viewModel.backgroundColor != nil
            && viewModel.textColor != nil
            && viewModel.bottomColor != nil) {
            self.backgroundColor = viewModel.backgroundColor;
            self.contentLabel.textColor = viewModel.textColor;
            self.avatarView.nameLabel.textColor = viewModel.textColor;
            
            self.commentCountLabel.textColor = viewModel.bottomColor;
            self.likeCountLabel.textColor = viewModel.bottomColor;
            [self.likeButton setTintColor:viewModel.bottomColor];
            self.targetLabel.textColor = viewModel.bottomColor;
            self.avatarView.subtitleLabel.textColor = viewModel.bottomColor;
            
        } else {
            self.backgroundColor = [UIColor whiteColor];
            self.contentLabel.textColor = [UIColor blackColor];
            self.avatarView.nameLabel.textColor = [UIColor blackColor];
            
            UIColor *grayColor = UIColorFromRGB(0x606065);
            self.commentCountLabel.textColor = grayColor;
            self.likeCountLabel.textColor = grayColor;
            [self.likeButton setTintColor:grayColor];
            self.avatarView.subtitleLabel.textColor = grayColor;
            self.targetLabel.textColor = grayColor;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonDidClick:(UIButton *)sender {
    [self.viewModel toggleLike];
}

- (void)setBlurry:(BOOL)blurry {
    _blurry = blurry;
    if (blurry) {
        self.effectView.hidden = NO;
        self.effectView.frame = self.bounds;
        self.deleteLabel.frame = self.bounds;
        if (self.viewModel.textColor != nil) {
            self.deleteLabel.textColor = self.viewModel.textColor;
        } else {
            self.deleteLabel.textColor = UIColorFromRGB(0x606065);
        }
    } else {
        _effectView.hidden = YES;
    }
}

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_effectView];
        
        _deleteLabel = [[UILabel alloc] initWithFrame:_effectView.frame];
        _deleteLabel.text = @"内容已被删除";
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
        [_effectView addSubview:_deleteLabel];
        
    }
    return _effectView;
}

@end
