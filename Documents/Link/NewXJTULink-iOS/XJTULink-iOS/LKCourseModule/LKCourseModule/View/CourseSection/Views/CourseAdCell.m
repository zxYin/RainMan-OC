//
//  CourseAdCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseAdCell.h"
#import "ViewsConfig.h"
#import "YPAdScrollView.h"
#import "CourseAdPageView.h"
#import "NoCourseView.h"
@interface CourseAdCell()<YPAdScrollViewDataSource,YPAdScrollViewDelegate>
@property (strong, nonatomic) YPAdScrollView *adScrollView;
@property (strong, nonatomic) NoCourseView *noCourseView;
@end

@implementation CourseAdCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.adScrollView.frame;
    frame.origin.y = 0;
    self.adScrollView.frame = frame;
    
    self.noCourseView.frame = CGRectMake(0, 0, MainScreenSize.width, 100);
    [self bringSubviewToFront:self.noCourseView];
}


#pragma mark - YPAdScrollViewDataSource
- (NSInteger)numberOfViewsInAdScrollView:(YPAdScrollView *)adScrollView {
    return self.viewModel.courseViewModels.count;
}

- (UIView *)adScrollView:(YPAdScrollView *)adScrollView cellForViewsAtIndex:(NSInteger)index {
    CourseAdPageView *page = [adScrollView dequeueReusableCellWithIdentifier:CourseAdPageViewIdentifier];
    page.viewModel = self.viewModel.courseViewModels[index];
    page.userInteractionEnabled = NO;
    return page;
}


#pragma mark - YPAdScrollViewDelegate
- (void)adScrollView:(YPAdScrollView *)adScrollView didTapViewAtIndex:(NSInteger)index {
    

}

#pragma mark - getter

- (YPAdScrollView *)adScrollView {
    if (_adScrollView == nil) {
        _adScrollView = [[YPAdScrollView alloc]initWithFrame:self.frame];
        _adScrollView.delegate = self;
        _adScrollView.dataSource = self;
        _adScrollView.currentPageIndicatorTintColor = [UIColor blackColor];
        _adScrollView.pageIndicatorTintColor = [UIColor lightGrayColor];
        _adScrollView.distanceToBottomOfPageControl = -15;
        _adScrollView.cycleEnabled = NO;
        
        UINib *nib = [UINib nibWithNibName:@"CourseAdPageView" bundle:nil];
        [_adScrollView registerNib:nib forCellReuseIdentifier:CourseAdPageViewIdentifier];
        
        [self addSubview:_adScrollView];
    }
    return _adScrollView;
}

- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [[RACObserve(self.viewModel, courseViewModels)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id x) {
         @strongify(self);
        [self.adScrollView reloadData];
     }];
    
    
    RAC(self.noCourseView, hidden) =
    [[RACObserve(self.viewModel, courseViewModels)
     takeUntil:self.rac_prepareForReuseSignal]
     map:^id(id value) {
        return @([value count] != 0);
    }];
}

- (NoCourseView *)noCourseView {
    if (_noCourseView == nil) {
        _noCourseView = [NoCourseView noCourseView];
        _noCourseView.hidden = YES;
        [self addSubview:_noCourseView];
    }
    return _noCourseView;
}

+ (CGFloat)height {
    return CourseAdCellHeight;
}

@end
