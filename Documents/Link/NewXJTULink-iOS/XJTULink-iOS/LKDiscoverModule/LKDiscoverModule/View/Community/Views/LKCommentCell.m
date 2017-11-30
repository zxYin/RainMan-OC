//
//  ConfessionCommentCell.m
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKCommentCell.h"
#import "LKAvatarView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Macros.h"
#import "Foundation+LKTools.h"
#import "ReactiveCocoa.h"
#import "UIView+YLAutoLayoutHider.h"
#import "Foundation+LKTools.h"
#import "UILabel+LKTextModel.h"
#import "BlocksKit+UIKit.h"
#import "ViewsConfig.h"
@interface LKCommentCell ()
@property (weak, nonatomic) IBOutlet LKAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;


@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation LKCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentContent.preferredMaxLayoutWidth = MainScreenSize.width - 81;
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(LKCommentViewModel *viewModel) {
        @strongify(self);
        [[RACObserve(viewModel, liked) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *liked) {
            if ([liked boolValue]) {
                [self.likeButton setImage:[UIImage imageNamed:@"wall_like_highlight"] forState:UIControlStateNormal];
            } else {
                [self.likeButton setImage:[UIImage imageNamed:@"wall_like_normal"] forState:UIControlStateNormal];
            }
        }];
        RAC(self.likeCountLabel, text) = [RACObserve(viewModel, likeCount) takeUntil:self.rac_prepareForReuseSignal];
        
        [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.user.avatarURL] placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
        self.avatarView.nameLabel.text = viewModel.user.nickname;
        self.avatarView.subtitleLabel.text = [NSString stringWithFormat:@"%@ %@",viewModel.time,viewModel.remark];
        [self.avatarView.tagLabel lk_setTextWithModel:self.viewModel.user.tag];

        
        if(viewModel.referUser
           && [NSString notBlank:viewModel.referUser.nickname]) {
            NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:@"回复"];
            NSAttributedString *name = [[NSAttributedString alloc] initWithString:viewModel.referUser.nickname attributes:@{NSForegroundColorAttributeName:self.tintColor}];
            
            [attrContent appendAttributedString:name];
            [attrContent appendAttributedString:[[NSAttributedString alloc] initWithString:@": "]];
            [attrContent appendAttributedString:[[NSAttributedString alloc] initWithString:viewModel.content]];
            self.commentContent.attributedText = attrContent;
        } else {
            self.commentContent.text = viewModel.content;
        }
    }];

    [self.commentContent bk_whenTapped:^{
        if (self.commentActionBlcok) {
            self.commentActionBlcok(self.viewModel);
        }
    }];
    
    
    
    
}
- (IBAction)likeCurrentComment:(id)sender {
    
    [self.viewModel toggleLike];
}


- (UIColor *)tintColor {
    if (_tintColor == nil) {
        _tintColor = LKColorLightBlue;
    }
    return _tintColor;
}


@end
