//
//  CourseListItemCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2017/4/18.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "CourseListItemCell.h"
#import "LKLabel.h"
@interface CourseListItemCell()
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet LKLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation CourseListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pointView.layer.cornerRadius = 4.0;
    self.pointView.clipsToBounds = YES;
    self.nameLabel.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    self.nameLabel.layer.cornerRadius = 4.0;
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.topLineView.layer.cornerRadius = 1.0;
    self.topLineView.clipsToBounds = YES;
    self.bottomLineView.layer.cornerRadius = 1.0;
    self.bottomLineView.clipsToBounds = YES;
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self);
        self.nameLabel.text = self.viewModel.name;
        self.localeLabel.text = self.viewModel.locale;
        self.rightLabel.text = self.viewModel.time;
    }];
    
    [RACObserve(self, tintColor) subscribeNext:^(id x) {
        @strongify(self);
        self.pointView.backgroundColor = [self.tintColor colorWithAlphaComponent:0.8];
        self.nameLabel.backgroundColor = [self.tintColor colorWithAlphaComponent:0.8];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
}


+ (CGFloat)height {
    return CourseListItemCellHeight;
}

@end
