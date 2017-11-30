//
//  YLAlertPanelButton.m
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAlertPanelButton.h"
#import "YLAlertPanelButtonImageView.h"
#import "YLAlertPanel.h"
@interface YLAlertPanelButton()
@property (nonatomic, copy) void (^handler)(YLAlertPanelButton * _Nonnull button);
@end
@implementation YLAlertPanelButton
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.frame = frame;
}


- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YLAlertPanelButtonWidth, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

-  (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[YLAlertPanelButtonImageView alloc] initWithFrame:CGRectMake(0, 0, YLAlertPanelButtonWidth, YLAlertPanelButtonWidth)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.cornerRadius = 15.0;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeCenter;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)];
        [_imageView addGestureRecognizer:tap];
        
    }
    return _imageView;
}

- (void)imageViewDidClick:(UITapGestureRecognizer*)tap {
    if (self.handler) {
        self.handler(self);
        [[YLAlertPanel currentPanel] dismiss];
    }
}


#pragma mark - Class Method
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image {
    return [self buttonWithTitle:title image:image handler:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image handler:(nullable void (^)(YLAlertPanelButton *button))handler {
    YLAlertPanelButton *button = [[YLAlertPanelButton alloc] init];
    button.frame = CGRectMake(0, 0, YLAlertPanelButtonWidth, YLAlertPanelButtonHeight);
    button.titleLabel.text = [title stringByAppendingString:@"\n\n"];
    button.handler = handler;
    button.imageView.image = image;
    return button;
}
@end
