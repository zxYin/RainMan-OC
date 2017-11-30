//
//  DiscoverAdPageView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DiscoverAdPageView.h"
#import "Masonry.h"
NSString *const DiscoverAdPageViewIdentifier = @"DiscoverAdPageViewIdentifier";
@interface DiscoverAdPageView()
//@property (nonatomic, strong) UIView
@end
@implementation DiscoverAdPageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return _imageView;
}


@end
