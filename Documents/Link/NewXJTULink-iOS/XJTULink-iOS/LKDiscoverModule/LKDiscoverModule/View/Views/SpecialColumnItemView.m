//
//  SpecialColumnItemView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SpecialColumnItemView.h"
#import "ViewsConfig.h"

@interface SpecialColumnItemView()

@end

@implementation SpecialColumnItemView

- (instancetype)initWithModel:(SingleURLModel *)model {
    self = [super initWithFrame:CGRectMake(0, 0, 64, 64)];
    if (self) {
        [self addSubview:self.tagLabel];
        [self addSubview:self.titleLabel];
        
        self.titleLabel.text = model.title;;
        [self.titleLabel sizeToFit];
        
        UIColor *color = nil;
        do {
            color =RandomFlatColorWithShadeAndAlpha(UIShadeStyleLight, 0.8);
//            [[UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight]
//            color = [[UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight] lightenByPercentage:0.3];
        } while (![color isDistinct:[UIColor whiteColor]]);
        self.backgroundColor = color;
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.tagLabel.center = CGPointMake(width/2, height/2 - 12);
    self.titleLabel.center = CGPointMake(width/2, height/2 + 12);
}


- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.text = @"#";
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"default";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

@end
