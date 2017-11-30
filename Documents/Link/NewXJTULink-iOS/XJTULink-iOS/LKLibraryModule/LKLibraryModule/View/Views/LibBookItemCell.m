//
//  LibBookItemCell.m
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibBookItemCell.h"

@interface LibBookItemCell()


@end

@implementation LibBookItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(LibBookViewModel *viewModel) {
        @strongify(self);
        self.titleLabel.text = viewModel.title;
        self.dateLabel.text = viewModel.date;
        self.countdownLabel.text = viewModel.countdown;
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - YLTableViewCellProtocol
- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

+ (CGFloat)height {
    return LibBookItemCellHeight;
}
@end
