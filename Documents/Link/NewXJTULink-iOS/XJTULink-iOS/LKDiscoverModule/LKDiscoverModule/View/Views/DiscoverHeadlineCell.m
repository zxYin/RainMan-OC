//
//  DiscoverHeadlineCell.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "DiscoverHeadlineCell.h"
#import "SDCycleScrollView.h"
#import "ViewsConfig.h"
@interface DiscoverHeadlineCell()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end
@implementation DiscoverHeadlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if([self.delegate respondsToSelector:@selector(discoverHeadlineCell:didTapViewAtIndex:)]) {
        [self.delegate discoverHeadlineCell:self didTapViewAtIndex:index];
    }
}


- (void)setViewModels:(NSArray<HeadlineModel *> *)viewModels {
    _viewModels = viewModels;
    
    self.cycleScrollView.titlesGroup = [viewModels bk_map:^id(HeadlineModel *viewModel) {
        return viewModel.title;
    }];
    
    self.cycleScrollView.imageURLStringsGroup = [viewModels bk_map:^id(HeadlineModel *viewModel) {
        return viewModel.imageURL.absoluteString;
    }];
    
}

- (SDCycleScrollView *)cycleScrollView {
    if(_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, DiscoverHeadlineCellHeight) delegate:self placeholderImage:nil];
        
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//        _cycleScrollView.titlesGroup = titles;
        _cycleScrollView.titlesGroup = [NSArray array];
        _cycleScrollView.imageURLStringsGroup = [NSArray array];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

@end
