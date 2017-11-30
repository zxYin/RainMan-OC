//
//  ClubItemCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubItemCell.h"
#import "ViewsConfig.h"
#import "Foundation+LKTools.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ClubItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *localImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@end
@implementation ClubItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.clubImageView.image = nil;
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(ClubViewModel *viewModel) {
        @strongify(self);
        self.nameLabel.text = viewModel.name;
        self.titleLabel.text = viewModel.honor;
        self.summaryLabel.text = viewModel.summary;
        
        [self.clubImageView sd_setImageWithURL:viewModel.imageURL
                              placeholderImage:[UIImage imageNamed:@"default_club_image"]];
        
        self.localeLabel.text = viewModel.locale;
        self.typeLabel.text = viewModel.type;
        
        self.shareButton.hidden = [NSString isBlank:self.viewModel.shareURLString];
    }];
}

//- (void)drawRect:(CGRect)rect {
//    [UIView drawLineFrom:CGPointMake(0, 0) to:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) withColor:LCOLOR_LIGHT_GRAY withWidth:1];
//}
- (IBAction)shareButtonDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clubItemCell:shareButtonDidClick:)]) {
        [self.delegate clubItemCell:self shareButtonDidClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
