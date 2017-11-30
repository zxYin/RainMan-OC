//
//  YLSearchBar.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSearchBar.h"
#import "ViewsConfig.h"
#import "UIImage+LKExpansion.h"
static NSString * const kDefaultPlaceholder = @"请输入关键字";


@interface LKSearchBar()<UITextFieldDelegate>

@end
@implementation LKSearchBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.searchIcon];
    [self.contentView addSubview:self.placeholderLabel];
    [self.contentView addSubview:self.inputTextField];
    
    [self addSubview:self.cancelButton];
    
    RAC(self.placeholderLabel, hidden) =
    [self.inputTextField.rac_textSignal map:^id(NSString *value) {
        return @([value length]>0);
    }];
    
    RAC(self, text) = self.inputTextField.rac_textSignal;
    
    RAC(self.placeholderLabel, text) =
    [RACObserve(self, placeholder) map:^id(NSString *value) {
        return value?:kDefaultPlaceholder;
    }];
    self.edgeInsets = UIEdgeInsetsMake(5, 10, 10, 60);
    self.style = kLKSearchBarStyleDefault;

}

- (void)layoutSubviews {
//    CGRect frame;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.edgeInsets);
    }];
    
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.contentView).offset(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputTextField);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (BOOL)becomeFirstResponder {
    return [self.inputTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cancelButton.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        [self.delegate searchBarDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}


- (void)setStyle:(LKSearchBarStyle)style {
    _style = style;
    switch (style) {
        case kLKSearchBarStyleBlack: {
            self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.inputTextField.textColor = [UIColor whiteColor];
            self.searchIcon.image = [UIImage imageNamed:@"search_navBar_icon"];
            self.placeholderLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
            break;
        }
        case kLKSearchBarStyleGray: {
            self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            self.inputTextField.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
            self.searchIcon.image = [[UIImage imageNamed:@"search_navBar_icon"]
                                     imageWithTintColor:[[UIColor grayColor] colorWithAlphaComponent:0.8]];
            self.placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
             break;
        }
        case kLKSearchBarStyleDefault: {
            self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
            self.inputTextField.textColor = [UIColor whiteColor];
            self.searchIcon.image = [UIImage imageNamed:@"search_navBar_icon"];
            self.placeholderLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        }
    }
}

#pragma mark - getter

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        _contentView.layer.cornerRadius = 2.0f;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)searchIcon {
    if (_searchIcon == nil) {
        _searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    }
    return _searchIcon;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.text = kDefaultPlaceholder;
    }
    return _placeholderLabel;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.font = [UIFont systemFontOfSize:16];
        _inputTextField.backgroundColor = [UIColor clearColor];
        _inputTextField.returnKeyType = UIReturnKeySearch;
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        @weakify(self);
        [_cancelButton bk_whenTapped:^{
            @strongify(self);
            self.text = @"";
            self.cancelButton.hidden = YES;
            [self endEditing:YES];
            if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
                [self.delegate searchBarCancelButtonClicked:self];
            }
        }];
        _cancelButton.hidden = YES;
        
    }
    return _cancelButton;
}

@end
