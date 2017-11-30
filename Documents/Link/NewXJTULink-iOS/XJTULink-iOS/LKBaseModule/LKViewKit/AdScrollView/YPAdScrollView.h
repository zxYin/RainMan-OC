//
//  YPAdScrollView.h
//  
//
//  Created by Yunpeng on 15/8/18.
//
//

#import <UIKit/UIKit.h>

@class YPAdScrollView;
@protocol YPAdScrollViewDataSource <NSObject>

/**
 *  从指定View开始
 *
 *  @param index view的索引值
 *
 *  @return NSInteger
 */
@optional
- (NSInteger) indexOfFirstView;

/**
 *  返回YPAdScrollView中View的个数
 *
 *  @param adScrollView YPAdScrollView的实例
 *
 *  @return NSInteger
 */
- (NSInteger)numberOfViewsInAdScrollView:(YPAdScrollView *)adScrollView;


/**
 *  返回一个view
 *
 *  @param adScrollView YPAdScrollView的实例
 *  @param index        view的索引值
 *
 *  @return UIView
 */
@required
- (UIView *)adScrollView:(YPAdScrollView *)adScrollView cellForViewsAtIndex:(NSInteger)index;

@optional
- (NSInteger)adScrollViewIntervalOfCarousel;
@end

@protocol YPAdScrollViewDelegate <NSObject>
@optional
/**
 *  滑动到index页
 *
 *  @param adScrollView YPAdScrollView的实例
 *  @param index        view的索引值
 *
 *  @return NSInteger
 */
- (void) adScrollView:(YPAdScrollView *)adScrollView didScrollToView:(NSInteger)index;

/**
 *  发生了点击事件
 *
 *  @param adScrollView YPAdScrollView的实例
 *  @param index        view的索引值
 */
- (void)adScrollView:(YPAdScrollView *)adScrollView didTapViewAtIndex:(NSInteger)index;

@end


@interface YPAdScrollView : UIView<UIScrollViewDelegate>
@property (weak,nonatomic) id<YPAdScrollViewDelegate> delegate;
@property (weak,nonatomic) id<YPAdScrollViewDataSource> dataSource;

@property (assign,nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL cycleEnabled;
@property (assign, nonatomic) BOOL pageControlEnabled;

@property (strong, nonatomic) UIColor *pageIndicatorTintColor;
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;
@property (assign, nonatomic) double distanceToBottomOfPageControl;
@property (assign, nonatomic) double distanceToRightOfPageControl;

@property (assign, nonatomic) CGFloat interval; // 如果为0，则不自动播放

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
@end
