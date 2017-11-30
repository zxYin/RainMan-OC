//
//  ConfessionMainContentCell.m
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/3/29.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKAnonymousPostDetailCell.h"
#import "Foundation+LKTools.h"
#import "UIView+YLAutoLayoutHider.h"
#import "LKLabel.h"
#import "UILabel+LKTextModel.h"

@interface LKAnonymousPostDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet LKLabel *acceptTag;



@end

@implementation LKAnonymousPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 22;
    
    self.referStudentBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
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
        self.readCountLabel.text = [NSString stringWithFormat:@"浏览了%@次",viewModel.readCount ];
        [[RACObserve(viewModel, liked) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *liked) {
            if ([liked boolValue]) {
                [self.likeBtn setImage:[UIImage imageNamed:@"wall_like_highlight"] forState:UIControlStateNormal];
            } else {
                [self.likeBtn setImage:[UIImage imageNamed:@"wall_like_normal"] forState:UIControlStateNormal];
            }
        }];
        [self.acceptTag lk_setTextWithModel:viewModel.tag];
        [[RACObserve(viewModel, accepted) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *liked) {
            if (viewModel.accepted) {
                [self.acceptTag lk_setTextWithModel:[LKPostViewModel acceptTextModel]];
            }
        }];
    }];
    
    
}

+ (instancetype)mainContentView {
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"ConfessionMainContentCell" owner:nil options:nil];
    return [nibViews firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 处理事件
- (IBAction)pressLikeBtn:(id)sender {
    [self.viewModel toggleLike];
}
- (IBAction)pressReferStudentBtn:(id)sender {
    if (self.referBlock) {
        self.referBlock();
    }
}


@end
