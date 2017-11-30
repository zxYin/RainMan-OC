//
//  ClubClassifyHeader.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubClassifyHeader.h"
#import "ViewsConfig.h"
#import "YLGridItemCell.h"
#import "Constants.h"
#import "UIImage+LKExpansion.h"
#import "Macros.h"

static const CGFloat YLGridItemCellWidth = 70;

@interface ClubClassifyHeader()
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, copy) UIView *selectedView;
@end
@implementation ClubClassifyHeader

- (instancetype)initWithTypes:(NSArray<NSDictionary *> *)clubTypes {
    self = [super initWithFrame:CGRectMake(0, 0, MainScreenSize.width, ClubClassifyHeaderHeight)];
    if (self) {
        [self setupRAC];
        self.items = clubTypes;
        [self setupSubViews];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [RACObserve(self, items) subscribeNext:^(id x) {
        self.contentScrollView.contentSize = CGSizeMake(YLGridItemCellWidth * self.items.count, ClubClassifyHeaderHeight);
        [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj != self.selectedView) {
                [obj removeFromSuperview];
            }
        }];
        [self.items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull type, NSUInteger idx, BOOL * _Nonnull stop) {
            
            YLGridItemCell *itemView = [[YLGridItemCell alloc] initWithFrame:CGRectMake(0, 0, YLGridItemCellWidth, YLGridItemCellHeight)];
            itemView.titleLabel.text = type[kClubTypeKeyTitle];
            itemView.imageView.image = [type[kClubTypeKeyImage]
                                        imageWithTintColor:[UIColor flatCoffeeDarkColor]];
            CGRect frame = itemView.frame;
            frame.origin.x = YLGridItemCellWidth * idx;
            frame.origin.y = 0;
            itemView.frame = frame;
            [itemView bk_whenTapped:^{
                @strongify(self);
                self.selectIndex = idx;
                if ([self.delegate respondsToSelector:@selector(clubClassifyHeader:didTapIndex:)]) {
                    [self.delegate clubClassifyHeader:self didTapIndex:idx];
                }
            }];
            [self.contentScrollView addSubview:itemView];
        }];
    }];
}

- (void)setupSubViews {
    [self addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.selectedView];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.items.count || selectIndex < 0) {
        return;
    }
    _selectIndex = selectIndex;
    
    CGPoint center = self.selectedView.center;
    center.x = YLGridItemCellWidth * (selectIndex+0.5);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectedView.center = center;
                     } completion:nil];
    [self fixOffset];
}


- (void)fixOffset {
    CGFloat offset = self.contentScrollView.contentOffset.x;
    CGFloat selectOffset = YLGridItemCellWidth * self.selectIndex;
    if (selectOffset > offset) {
        // 向右移动
        while (offset + MainScreenSize.width < selectOffset+YLGridItemCellWidth) {
            offset += 1;
        }
    
    } else {
        // 向左移动
        while (offset > selectOffset) {
            offset -= 1;
        }
    }

    offset = MIN(MAX(offset,0),self.contentScrollView.contentSize.width - MainScreenSize.width);
    [self.contentScrollView setContentOffset: CGPointMake(offset, 0) animated:YES];
}

- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, ClubClassifyHeaderHeight)];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        
    }
    return _contentScrollView;
}

- (UIView *)selectedView {
    if (_selectedView == nil) {
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, YLGridItemCellHeight, 50, 2)];
        _selectedView.backgroundColor = LKColorOrange;
        _selectedView.layer.cornerRadius = 0.3;
        _selectedView.clipsToBounds = YES;
    }
    return _selectedView;
}
@end
