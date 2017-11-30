//
//  SpecialColumnView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "SpecialColumnView.h"
#import "ViewsConfig.h"
#import "SpecialColumnItemView.h"
@interface SpecialColumnView()
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation SpecialColumnView
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self setupRAC];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 0, 0, 0));
    }];
}

- (void)setupRAC {
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(SpecialColumnModel *viewModel) {
        @strongify(self);
        // 清空旧的
        [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        CGFloat startOffset = 25;
        CGFloat offset = 75;
        self.contentScrollView.contentSize = CGSizeMake(startOffset + offset * viewModel.items.count, 70);
        @weakify(self);
        [viewModel.items enumerateObjectsUsingBlock:^(SingleURLModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SpecialColumnItemView *itemView = [[SpecialColumnItemView alloc] initWithModel:obj];
            CGRect frame = itemView.frame;
            frame.origin.x = startOffset + offset * idx;
            frame.origin.y = 0;
            itemView.frame = frame;
            [itemView bk_whenTapped:^{
                @strongify(self);
                
                if ([self.delegate respondsToSelector:@selector(specialColumn:didTapIndex:)]) {
                    [self.delegate specialColumn:self didTapIndex:idx];
                }
            }];
            [self.contentScrollView addSubview:itemView];
        }];
    }];
}

- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        
    }
    return _contentScrollView;
}
@end
