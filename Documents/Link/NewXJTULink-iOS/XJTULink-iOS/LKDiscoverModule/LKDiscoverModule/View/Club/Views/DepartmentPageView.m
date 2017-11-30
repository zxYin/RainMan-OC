//
//  DepartmentPageView.m
//  DepartmentPageView
//
//  Created by Yunpeng on 16/7/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DepartmentPageView.h"
#import "ViewsConfig.h"
@interface DepartmentPageView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YYLabel *contentLabel;
@end
@implementation DepartmentPageView
#pragma mark - init
- (instancetype)init {
    self = [super init];
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithModel:(DepartmentModel *)model {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setupSubViews];
        [self.backgroundImageView sd_setImageWithURL:model.imageURL];
        self.title = model.name;
        self.content = model.introduction;
    }
    return self;
}


- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.contentLabel];
    
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}




- (BOOL)isLeftGreaterThanRight {
    return self.leftHeight>self.rightHeight;
}

- (void)layoutSubviews {
    CGSize size = self.frame.size;
    CGRect frame;
    
    frame = self.contentLabel.frame;
    frame.origin.y = MIN(80, fabs(self.leftHeight-self.rightHeight)) + size.height - MAX(self.leftHeight,self.rightHeight);
    self.contentLabel.frame = frame;

    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *title = [[NSAttributedString alloc]
                                 initWithString:self.title attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:35]
                                                                        }];
    NSAttributedString *content = [[NSAttributedString alloc]
                                 initWithString:[@"\n\n" stringByAppendingString:self.content] attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                        }];
    
    [text appendAttributedString:title];
    [text appendAttributedString:content];
    text.yy_color = [UIColor whiteColor];
    text.yy_alignment = self.isLeftGreaterThanRight ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    self.contentLabel.attributedText = text;
    self.contentLabel.textContainerInset =
    self.isLeftGreaterThanRight ? UIEdgeInsetsMake(0, 15, 0, 5) : UIEdgeInsetsMake(0, 5, 0, 15);
    

}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.frame.size;
    CGPoint pointA = CGPointMake(0, size.height - self.leftHeight);
    CGPoint pointB = CGPointMake(size.width, size.height - self.rightHeight);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, pointA.x, pointA.y);
    CGPathAddLineToPoint(path, NULL, pointB.x, pointB.y);
    CGPathAddLineToPoint(path, NULL, size.width, size.height);
    CGPathAddLineToPoint(path, NULL, 0, size.height);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);;
    self.contentView.layer.mask = shapeLayer;
    
    if (pointB.y == pointA.y) {
        return;
    }
    
    CGFloat y = CGRectGetMinY(self.contentLabel.frame);
    CGFloat x = (y - pointA.y)/(pointB.y - pointA.y) * (pointB.x - pointA.x) + pointA.x;
    CGMutablePathRef contentPath = CGPathCreateMutable();
    
    CGFloat margin = 15;
    if (self.leftHeight > self.rightHeight) {
        CGPathMoveToPoint(contentPath, NULL, x - margin, 0);
        CGPathAddLineToPoint(contentPath, NULL, pointB.x - margin, pointB.y - y);
        CGPathAddLineToPoint(contentPath, NULL, pointB.x, pointB.y - y);
        CGPathAddLineToPoint(contentPath, NULL, pointB.x - margin, 0);
    } else {
        CGPathMoveToPoint(contentPath, NULL, x + margin, 0);
        CGPathAddLineToPoint(contentPath, NULL, pointA.x + margin, pointA.y - y);
        CGPathAddLineToPoint(contentPath, NULL, pointA.x , pointA.y - y);
        CGPathAddLineToPoint(contentPath, NULL, pointA.x , 0);
    }
    CGPathCloseSubpath(contentPath);
    self.contentLabel.exclusionPaths = @[[UIBezierPath bezierPathWithCGPath:contentPath]];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:self.frame];
        _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _contentView;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}



- (YYLabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 500)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
@end
