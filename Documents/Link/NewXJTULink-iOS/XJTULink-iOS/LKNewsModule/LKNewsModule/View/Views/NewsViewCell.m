//
//  IndexNewsViewCell.m
//  XJTUIn
//
//  Created by 李云鹏 on 15/5/6.
//  Copyright (c) 2015年 李云鹏. All rights reserved.
//

#import "NewsViewCell.h"
#import <ReactiveCocoa.h>

NSString *const NewsViewCellIdentifier = @"NewsViewCell";
@interface NewsViewCell()


@end

@implementation NewsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, viewModel)
      subscribeNext:^(NewsItemViewModel *viewModel) {
        @strongify(self);
        self.titleLabel.text = viewModel.title;
        self.timeLabel.text = viewModel.date;
        self.tagView.hidden = viewModel.boxHidden;
    }] ;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *backgroundColor = self.tagView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.tagView.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *backgroundColor = self.tagView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.tagView.backgroundColor = backgroundColor;
}

#pragma mark - YLTableViewCellProtocol
- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

+ (CGFloat)height {
    return NewsViewCellHeight;
}

@end
