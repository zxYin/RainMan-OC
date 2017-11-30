//
//  LectureItemCell.m
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LectureItemCell.h"
NSString * const LectureItemCellIdentifier = @"LectureItemCell";
@implementation LectureItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    
    @weakify(self);
    [RACObserve(self, viewModel)
     subscribeNext:^(LectureItemViewModel *viewModel) {
         @strongify(self);
         self.titleLabel.text = viewModel.title;
         self.timeLabel.text = viewModel.time;
     }];
}


#pragma mark - YLTableViewCellProtocol
- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

+ (CGFloat)height {
    return LectureViewCellHeight;
}
@end
