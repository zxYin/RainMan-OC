//
//  LKTextView.m
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "LKTextView.h"

@interface LKTextView ()
@property (nonatomic, strong) UITextView *placeholderView;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat maxTextHeight;

@end

@implementation LKTextView
@dynamic placeholderColor, cornerRadius, borderWidth, borderColor;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.placeholderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textDidChange:(NSNotification *)notification {
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (_textHeight != height) {
        if(self.maxNumberOfLines != 0) {
            self.scrollEnabled = height > self.maxTextHeight && self.maxTextHeight > 0;
        }
        _textHeight = height;
        if (_textHeightChangeBlock && self.scrollEnabled == NO) {
            _textHeightChangeBlock(self, self.text, height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange:nil];
}

#pragma mark - Getter && Setter
- (UITextView *)placeholderView {
    if (_placeholderView == nil) {
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _placeholderView = [[UITextView alloc] initWithFrame:frame];
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = cornerRadius > 0;
}

- (void)setTextHeightChangeBlock:(void (^)(LKTextView *textView, NSString *text, CGFloat textHeight))textChangeBlock {
    _textHeightChangeBlock = textChangeBlock;
    [self textDidChange:nil];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)placeholderColor {
    return self.placeholderView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderView.text = placeholder;
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderView.font = font;
}
@end
