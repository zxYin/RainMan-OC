//
//  HomePageHeaderView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "HomePageHeaderView.h"
@interface HomePageHeaderView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moreLabel;
@property (strong, nonatomic) UIView *bottomLineView;
@end
@implementation HomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self!=nil) {
        self.lineSpaceToBottom = 0.0;
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 10, 100, 20)];
        _titleLabel.textColor = UIColorFromRGB(0x868686);
        _titleLabel.font = [UIFont fontWithName:@"STYuanti-SC-Regular" size:17];
        
        [self addSubview:_titleLabel];
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(13, 12, 3.5, 18)];
        dotView.backgroundColor = LKColorLightBlue;
        dotView.layer.cornerRadius = 2.5;
        dotView.layer.masksToBounds = YES;
        [self addSubview:dotView];
        
        _moreLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-73, 15, 73, 20)];
        _moreLabel.text = @"显示全部>";
        _moreLabel.font = [UIFont systemFontOfSize:13];
        _moreLabel.textColor = UIColorFromRGB(0xe5e5e5);
        [self addSubview:_moreLabel];
        _moreLabel.hidden = YES;
        
        
//        [self addSubview:self.bottomLineView];
    }
    return self;
    
}


- (void)drawRect:(CGRect)rect {
//     Drawing code
    int y = self.frame.size.height - self.lineSpaceToBottom;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.3);
    CGContextSetStrokeColorWithColor(context,UIColorFromRGB(0xe5e5e5).CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 13, y);
    CGContextAddLineToPoint(context, [UIScreen mainScreen].bounds.size.width - 13, y);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bottomLineView.frame;
    frame.origin.y = self.frame.size.height - self.lineSpaceToBottom;
    self.bottomLineView.frame = frame;
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        
        _titleLabel.text = _title;
        [self setNeedsDisplay];
    }
}

- (void)setIsShowMore:(BOOL)isShowMore {
    if (_isShowMore != isShowMore) {
        _isShowMore = isShowMore;
        if (isShowMore) {
            _moreLabel.hidden = NO;
        } else {
            _moreLabel.hidden = YES;
        }
    }
}

//- (UIView *)bottomLineView {
//    if (_bottomLineView == nil) {
//        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, [UIScreen mainScreen].bounds.size.width - 13, 1.3)];
//        _bottomLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
//    }
//    return _bottomLineView;
//}
@end
