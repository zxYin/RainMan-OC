//
//  DiscoverAdCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DiscoverAdCell.h"
#import "DiscoverAdPageView.h"
#import "ViewsConfig.h"
NSString *const DiscoverAdCellHeightIdentifier = @"DiscoverAdCellHeightIdentifier";
@interface DiscoverAdCell ()
@property (strong, nonatomic) YPAdScrollView *adScrollView;
@property (strong, nonatomic) UIView *titleBackgroundView;
@end

@implementation DiscoverAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setupRAC];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.adScrollView.frame;
    frame.origin.y = 0;
    self.adScrollView.frame = frame;
    
    frame = self.frame;
    frame.size.height = 35;
    frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame);
    self.titleBackgroundView.frame = frame;
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleBackgroundView).offset(2);
        make.left.mas_equalTo(10);
        make.right.mas_greaterThanOrEqualTo(70);
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}


#pragma mark - YPAdScrollViewDataSource
- (NSInteger)numberOfViewsInAdScrollView:(YPAdScrollView *)adScrollView {
    return self.viewModels.count;
}

- (UIView *)adScrollView:(YPAdScrollView *)adScrollView cellForViewsAtIndex:(NSInteger)index {
    DiscoverAdPageView *cell = [adScrollView dequeueReusableCellWithIdentifier:DiscoverAdPageViewIdentifier];
    [cell.imageView sd_setImageWithURL:self.viewModels[index].imageURL];
    cell.userInteractionEnabled = NO;
    cell.clipsToBounds = YES;
    return cell;
}

//- (NSInteger)adScrollViewIntervalOfCarousel {
//    if ([self.delegate respondsToSelector:@selector(discoverAdCellintervalOfCarousel)]) {
//        return [self.delegate discoverAdCellintervalOfCarousel];
//    }
//    return 4;
//}


#pragma mark - YPAdScrollViewDelegate
- (void)adScrollView:(YPAdScrollView *)adScrollView didTapViewAtIndex:(NSInteger)index {
    if([self.delegate respondsToSelector:@selector(discoverAdCell:didTapViewAtIndex:)]) {
        [self.delegate discoverAdCell:self didTapViewAtIndex:index];
    }
}

- (void) adScrollView:(YPAdScrollView *)adScrollView didScrollToView:(NSInteger)index {
    _visiableIndex = index;
    self.titleLabel.text = self.viewModels[index].title;
}

- (YPAdScrollView *)adScrollView {
    if (_adScrollView == nil) {
        _adScrollView = [[YPAdScrollView alloc]initWithFrame:self.frame];
        _adScrollView.delegate = self;
        _adScrollView.dataSource = self;
        _adScrollView.currentPageIndicatorTintColor = [UIColor whiteColor];
        _adScrollView.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        _adScrollView.distanceToBottomOfPageControl = -3;
        
        
        _adScrollView.distanceToRightOfPageControl = MainScreenSize.width<375? 0.1 : 10;
        _adScrollView.cycleEnabled = YES;
        _adScrollView.interval = 4.0;
        
        [_adScrollView registerClass:[DiscoverAdPageView class]
              forCellReuseIdentifier:DiscoverAdPageViewIdentifier];
        [self.contentView insertSubview:_adScrollView atIndex:0];
    }
    return _adScrollView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.userInteractionEnabled = NO;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)titleBackgroundView {
    if (_titleBackgroundView == nil) {
        _titleBackgroundView = [[UIView alloc] init];
        _titleBackgroundView.userInteractionEnabled = NO;
        _titleBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.contentView addSubview:_titleBackgroundView];

    }
    return _titleBackgroundView;
}

- (void)setViewModels:(NSArray<HeadlineModel *> *)viewModels {
    _viewModels = viewModels;
    [self.adScrollView reloadData];
    [self adScrollView:self.adScrollView didScrollToView:0];
}
@end
