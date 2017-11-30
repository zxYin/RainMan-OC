//
//  ConfessionItemCell.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKAnonymousPostCell.h"
#import "Foundation+LKTools.h"
#import "Macros.h"
#import "UIImageView+LKTools.h"
#import "UILabel+LKTextModel.h"
#import "UIView+YLAutoLayoutHider.h"
@interface LKAnonymousPostCell()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UILabel *deleteLabel;
@end
@implementation LKAnonymousPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.likeCountLabel.userInteractionEnabled = NO;
    CGFloat WIDTH = self.frame.size.width;
    self.contentLabel.preferredMaxLayoutWidth = WIDTH - 22;
    self.commentCountLabel.preferredMaxLayoutWidth = WIDTH;
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(LKPostViewModel *viewModel) {
        @strongify(self);
        if ([NSString notBlank:viewModel.referStudent]) {
            [self.targetLabel yl_setHidden:NO forType:YLHiddenTypeVertical];
            self.targetLabel.text = [NSString stringWithFormat:@"To: %@",viewModel.referStudent];
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
        
        self.timeLabel.text = viewModel.time;
        self.hotImageView.hidden = !viewModel.isHot;
        
        RAC(self.likeCountLabel, text) = [RACObserve(viewModel, likeCount) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.commentCountLabel, text) = [RACObserve(viewModel, commentCount) takeUntil:self.rac_prepareForReuseSignal];
        
        [RACObserve(viewModel, tag) subscribeNext:^(id x) {
            [self.tagLabel lk_setTextWithModel:viewModel.tag];
        }];
        
        
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
            self.targetLabel.textColor = viewModel.textColor;
            
            self.commentCountLabel.textColor = viewModel.bottomColor;
            self.timeLabel.textColor = viewModel.bottomColor;
            self.likeCountLabel.textColor = viewModel.bottomColor;
            [self.likeButton setTintColor:viewModel.bottomColor];
            
        } else {
            self.backgroundColor = [UIColor whiteColor];
            self.contentLabel.textColor = [UIColor blackColor];
            self.targetLabel.textColor = [UIColor blackColor];
            
            UIColor *grayColor = UIColorFromRGB(0x606065);
            self.commentCountLabel.textColor = grayColor;
            self.timeLabel.textColor = grayColor;
            self.likeCountLabel.textColor = grayColor;
            [self.likeButton setTintColor:grayColor];
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
