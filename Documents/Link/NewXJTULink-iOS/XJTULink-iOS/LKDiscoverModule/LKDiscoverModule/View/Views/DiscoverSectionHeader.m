//
//  DiscoverSectionHeader.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DiscoverSectionHeader.h"
#import "ViewsConfig.h"
const CGFloat DiscoverSectionHeaderHeight = 20;
@implementation DiscoverSectionHeader
+ (instancetype)discoverSectionHeaderWithTitle:(NSString *)title {
    DiscoverSectionHeader *header = [[DiscoverSectionHeader alloc] init];
    header.titleLabel.text = title;
    return header;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(10);
    }];
}


- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
