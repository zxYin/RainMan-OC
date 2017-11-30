//
//  InteractionMessageCell.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/30.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "InteractionMessageCell.h"
#import "InteractionMessage.h"
#import "NSDate+LKTools.h"
#import "UILabel+LKTextModel.h"
#import "Foundation+LKTools.h"
#import "Chameleon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+YLAutoLayoutHider.h"

@interface InteractionMessageCell()
@property (weak, nonatomic) InteractionMessage *model;
@property (weak, nonatomic) IBOutlet UIView *referContainerView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end
@implementation InteractionMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    self.contentLabel.preferredMaxLayoutWidth = WIDTH - 29;
    self.referContentLabel.preferredMaxLayoutWidth = WIDTH - 42;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configWithModel:(InteractionMessage *)model {
    self.model = model;
    [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
    self.avatarView.nameLabel.text = model.user.nickname;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.timestamp];
    self.avatarView.subtitleLabel.text = [date lk_timeString];

    [self.avatarView.tagLabel lk_setTextWithModel:model.user.tag];
    
    UIColor *tintColor = [UIColor colorWithHexString:model.tintColor]?:[UIColor blackColor];
    //        self.operationLabel.textColor = tintColor;
    [self.replyButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    if ([NSString notBlank:model.content]) {
        [self.contentLabel yl_setHidden:NO forType:YLHiddenTypeVertical];

        if([NSString notBlank:model.referName]) {
            NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:@"回复"];
            NSAttributedString *name = [[NSAttributedString alloc] initWithString:model.referName attributes:@{NSForegroundColorAttributeName:tintColor}];
            
            [attrContent appendAttributedString:name];
            [attrContent appendAttributedString:[[NSAttributedString alloc] initWithString:@": "]];
            [attrContent appendAttributedString:[[NSAttributedString alloc] initWithString:model.content]];
            self.contentLabel.attributedText = attrContent;
        } else {
            self.contentLabel.text = model.content;
        }
        
    } else {
        [self.contentLabel yl_setHidden:YES forType:YLHiddenTypeVertical];
    }
    
    if ([NSString notBlank:model.referContent]) {
        [self.referContainerView yl_setHidden:NO forType:YLHiddenTypeVertical];
        self.referContentLabel.text = model.referContent;
    } else {
        [self.referContainerView yl_setHidden:YES forType:YLHiddenTypeVertical];
    }
    
    
    self.operationLabel.text = model.operation;
    self.replyButton.hidden = !model.allowReply;
}

- (IBAction)replyButtonDidClick:(id)sender {
    if (self.replyButtonDidClickBlock) {
        NSString *placeholder = [NSString stringWithFormat:@"回复%@:",self.model.user.nickname];
        self.replyButtonDidClickBlock(self.model, placeholder);
    }
}
@end
