//
//  YLGridItemCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLGridItemCell.h"
#import "Masonry.h"
#import "LKTouchableView.h"
NSString *const YLGridItemCellIdentifier = @"YLGridItemCellIdentifier";
@interface YLGridItemCell()
//@property (nonatomic, strong) LKTouchableView *touchView;

@end

@implementation YLGridItemCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    UIView *superView = self;
//    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.bottom.equalTo(superView).offset(-5).priorityHigh();
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(superView);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-7);
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.imageView.tintColor = tintColor;
    self.titleLabel.tintColor = tintColor;
}

//- (LKTouchableView *)touchView {
//    if (_touchView) {
//        _touchView = [[LKTouchableView alloc] init];
//        _touchView.backgroundColor = [UIColor whiteColor];
//        self.contentView.userInteractionEnabled = NO;
//    }
//    return _touchView;
//}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
