//
//  YLAlertPanelLine.m
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAlertPanelLine.h"
@interface YLAlertPanelLine()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIView *> *buttons;
@end

@implementation YLAlertPanelLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.edges = UIEdgeInsetsMake(15, 8, 10, 8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        [self addSubview:self.scrollView];
    
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    CGFloat offset = 6;
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat width = self.edges.left + (YLAlertPanelButtonWidth + 2 * offset) * self.buttons.count + self.edges.right;
    self.scrollView.contentSize = CGSizeMake(MAX(width,[UIScreen mainScreen].bounds.size.width + 1), YLAlertPanelLineHeight);
    
    [self.buttons enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"第 %td 个 button",idx);
        CGRect frame = view.frame;
        frame.origin.x = self.edges.left + (YLAlertPanelButtonWidth + 2 * offset) * idx + self.edges.right;
        frame.origin.y = self.edges.top;
        view.frame = frame;
    }];
    
}

- (NSInteger)addButtonWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(YLAlertPanelButton *button))handler {
    return [self insertButtonWithTitle:title image:image atIndex:NSIntegerMax handler:handler];
}

- (NSInteger)insertButtonWithTitle:(NSString *)title image:(UIImage *)image atIndex:(NSInteger)index handler:(void (^)(YLAlertPanelButton *button))handler {
    YLAlertPanelButton *button = [YLAlertPanelButton buttonWithTitle:title image:image handler:handler];
    
    if (index<0) {
        index = 0;
    } else if(index > self.buttons.count) {
        index = self.buttons.count;
    }
    
    [self.buttons insertObject:button atIndex:index];
    [self.scrollView addSubview:button];
    self.countOfButtons = self.buttons.count;
    return index;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (NSMutableArray<UIView *> *)buttons {
    if (_buttons == nil) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

@end
