
//
//  YPAdScrollView.m
//
//
//  Created by Yunpeng on 15/8/18.
//
//

#import "YPAdScrollView.h"
#import <objc/runtime.h>
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height



@interface YPAdScrollView() {
    NSInteger size;
    NSInteger contentCount;
    CGFloat contentOffset;
    UIScrollView *mScrollView;
    UIPageControl *pageControl;
    NSMutableDictionary *loadedCells;
    NSMutableSet *cellBuffer;
    
    
    Class cellClass;
    NSString *cellIdentifier;
    UINib *cellNib;
}

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation YPAdScrollView

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self!=nil) {
        mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self!=nil) {
        mScrollView = [[UIScrollView alloc]initWithCoder:aDecoder];
        CGRect frame = mScrollView.frame;
        frame.origin = CGPointMake(0, 0);
        mScrollView.frame = frame;
        [self initData];
    }
    return self;
}


- (void) initData {
    cellBuffer = [[NSMutableSet alloc]init];
    loadedCells = [[NSMutableDictionary alloc]initWithCapacity:3];
    self.cycleEnabled = YES;
    self.pageControlEnabled = YES;  //默认 YES
    mScrollView.bounces = NO;
    mScrollView.pagingEnabled = YES;
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.delegate = self;
    [self addSubview:mScrollView];
    
    self.currentIndex = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [mScrollView addGestureRecognizer:tapGesture];
    
    if (self.pageControlEnabled) {
        pageControl = [[UIPageControl alloc]init];
    
        UIColor *pageIndicatorTintColor = [UIColor grayColor];
        UIColor *currentPageIndicatorTintColor = [UIColor whiteColor];
        pageIndicatorTintColor = self.pageIndicatorTintColor;
        currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        pageControl.center = self.center;
        self.distanceToBottomOfPageControl = 15; // 默认
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        pageControl.enabled = NO;
        
        [self addSubview:pageControl];
    }
    
    
}

- (void)registerClass:(Class)c forCellReuseIdentifier:(NSString *)identifier {
    cellClass = c;
    cellIdentifier = identifier;
}


- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    cellNib = nib;
    cellIdentifier = identifier;
}

static char identifierKey;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    UIView *cell = [cellBuffer anyObject];
    if (cell && [objc_getAssociatedObject(cell, &identifierKey) isEqualToString:identifier]) {
        [cellBuffer removeObject:cell];
        return cell;
    }
    
    UIView *view = nil;
    if(cellNib) {
        view = [[cellNib instantiateWithOwner:nil options:nil] firstObject];
    } else if(cellClass) {
        view = [[cellClass alloc] initWithFrame:self.frame];
    } else {
        NSException *e = [NSException
                          exceptionWithName: @"Unkown Class"
                          reason: @"You must register class before use dequeueReusableCellWithIdentifier"
                          userInfo: nil];
        @throw e;
    }
    objc_setAssociatedObject(view,&identifierKey,cellIdentifier,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return view;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}


- (void)reloadData {
    for (UIView *subView in mScrollView.subviews) {
        [subView removeFromSuperview];
    }
    size = [self.dataSource numberOfViewsInAdScrollView:self];
    switch (size) {
        case 0:
            return;
        case 1:
            self.cycleEnabled = NO;
            self.pageControlEnabled = NO;
            break;
        case 2:
            self.cycleEnabled = NO;
            break;
        default:
            break;
    }
    
    if ([self.dataSource respondsToSelector:@selector(indexOfFirstView)]) {
        self.currentIndex = [self.dataSource indexOfFirstView];
    }
    
    contentOffset = self.cycleEnabled?1:0;
    contentCount = size + 2 * contentOffset;
    mScrollView.contentSize = CGSizeMake(WIDTH * contentCount, HEIGHT);
    [mScrollView setContentOffset:CGPointMake(WIDTH*(self.currentIndex+contentOffset), 0)];
    
    [self prepareForCellAtIndex:self.currentIndex];
    [self prepareForCellAtIndex:self.currentIndex+1];
    [self prepareForCellAtIndex:self.currentIndex-1];
    
    
    if (self.pageControlEnabled) {
        pageControl.numberOfPages = size;
        pageControl.currentPage = self.currentIndex;
        CGSize pageControlSize = [pageControl sizeForNumberOfPages:size];
        CGRect frame = pageControl.frame;
        if(self.distanceToBottomOfPageControl != 0) {
            frame.origin.y = CGRectGetHeight(self.frame) - pageControlSize.height - self.distanceToBottomOfPageControl;
        }
        
        if(self.distanceToRightOfPageControl != 0) {
            frame.origin.x = CGRectGetWidth(self.frame) - pageControlSize.width - self.distanceToRightOfPageControl;
        }
        pageControl.frame = frame;
        
    }
    
    if(self.cycleEnabled) {
        if (self.currentIndex == 0) {
            [mScrollView setContentOffset:CGPointMake(WIDTH*2, 0)];
            [mScrollView setContentOffset:CGPointMake(WIDTH, 0)];
        } else if(self.currentIndex == size -1) {
            [mScrollView setContentOffset:CGPointMake(WIDTH * (size -1), 0)];
            [mScrollView setContentOffset:CGPointMake(WIDTH * size, 0)];
            
        }
    }
    
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adScrollView:didTapViewAtIndex:)]) {
        [self.delegate adScrollView:self didTapViewAtIndex:self.currentIndex];
    }
    
}


- (void)prepareForCellAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(adScrollView:cellForViewsAtIndex:)]) {
        index = (index+size) %size;
        if (index < 0 || index>= size) {
            return;
        }
        UIView *view = [self.dataSource adScrollView:self cellForViewsAtIndex:index];
        view.frame = CGRectMake(WIDTH * (index+contentOffset), 0, WIDTH, HEIGHT);
        [loadedCells setObject:view forKey:[NSNumber numberWithInteger:index]];
        [mScrollView addSubview:view];
        [mScrollView sendSubviewToBack:view];
    }
}

#pragma mark - timer

- (void)scrollToNextPage {
    NSLog(@"scrollToNextPage");
    if ([self.dataSource respondsToSelector:@selector(adScrollViewIntervalOfCarousel)]) {
        CGFloat interval = [self.dataSource adScrollViewIntervalOfCarousel];
        if(self.interval != interval) {
            self.interval = interval;
        }
    }
    
    [mScrollView setContentOffset:CGPointMake((self.currentIndex + 1 + contentOffset) * WIDTH, 0) animated:YES];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    mScrollView.frame = frame;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.interval = self.interval; // 重启timer
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger newIndex = (scrollView.contentOffset.x / WIDTH) - contentOffset;
    NSInteger currentContentOffsetIndex = self.currentIndex + contentOffset;

    
    NSInteger direction = newIndex - self.currentIndex;
    if (ABS(newIndex - self.currentIndex)!=1 ) {
        return;
    }

    NSInteger removeIndex, prepareIndex;
    
        
    newIndex = (newIndex + size) % size;
    removeIndex = 2 * self.currentIndex - newIndex;
    prepareIndex = 2 * newIndex-self.currentIndex;
    
    removeIndex = (removeIndex+size) % size;
    prepareIndex = (prepareIndex+size) % size;
    
    
    NSNumber *removeIndexN = [NSNumber numberWithInteger:removeIndex];
    UIView* removeCell = [loadedCells objectForKey:removeIndexN];
    if (removeCell!=nil) {
        [cellBuffer addObject:removeCell];
        [removeCell removeFromSuperview];
        [loadedCells removeObjectForKey:removeIndexN];
    }
    
    [self prepareForCellAtIndex:prepareIndex];

    
    
    NSInteger lastIndex = self.currentIndex;
    self.currentIndex = newIndex;
    
    pageControl.currentPage = self.currentIndex;
    if([self.delegate respondsToSelector:@selector(adScrollView:didScrollToView:)]) {
        [self.delegate adScrollView:self didScrollToView:self.currentIndex];
    }
    
    if(!self.cycleEnabled) {
        return;
    }
    
    
    //将准备好的cell[0]转到端尾 或 将准备好的cell[size]转到端首
    if (ABS(prepareIndex-self.currentIndex)!=1) {
//        NSLog(@"prepareIndex=%ld,newIndex=%ld",prepareIndex,currentIndex);
//        NSLog(@"将cell[%ld]转移到%ld区域",prepareIndex,currentIndex+contentOffset+direction);
        UIView *view = [loadedCells objectForKey:[NSNumber numberWithInteger:prepareIndex]];
        view.frame = CGRectMake(WIDTH*(self.currentIndex+contentOffset+direction), 0, WIDTH, HEIGHT);
        
    }
    
    
    // 将cell[size-1]、cell[0]从一端同时转移到另一端
    if (ABS(self.currentIndex-lastIndex)!=1) {
        NSInteger pos = currentContentOffsetIndex-direction*size;
        UIView *view= nil;
        
        
//        NSLog(@"将cell[%ld]移动到%ld区域",(currentIndex+direction+size)%size,pos2+direction);
        view = [loadedCells objectForKey:[NSNumber numberWithInteger:(lastIndex+direction+size)%size]];
        view.frame = CGRectMake(WIDTH*(pos+direction), 0, WIDTH, HEIGHT);
//         NSLog(@"将cell[%ld]移动到%ld区域",currentIndex,pos2);
        view = [loadedCells objectForKey:[NSNumber numberWithInteger:lastIndex]];
        view.frame = CGRectMake(WIDTH*(pos), 0, WIDTH, HEIGHT);
        [scrollView setContentOffset:CGPointMake(WIDTH*(self.currentIndex+contentOffset), 0)];

    }
    
}


- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    if (_pageIndicatorTintColor != pageIndicatorTintColor) {
        _pageIndicatorTintColor = pageIndicatorTintColor;
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    if (_currentPageIndicatorTintColor != currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
}

- (void)setDistanceToBottomOfPageControl:(double)distanceToBottomOfPageControl {
    if (_distanceToBottomOfPageControl != distanceToBottomOfPageControl) {
        _distanceToBottomOfPageControl = distanceToBottomOfPageControl;
        CGRect frame = pageControl.frame;
        frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame) - distanceToBottomOfPageControl;
        pageControl.frame = frame;
    }
}

- (void)setDistanceToRightOfPageControl:(double)distanceToRightOfPageControl {
    if (_distanceToRightOfPageControl != distanceToRightOfPageControl) {
        _distanceToRightOfPageControl = distanceToRightOfPageControl;
        CGRect frame = pageControl.frame;
        frame.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(frame) - distanceToRightOfPageControl;
        pageControl.frame = frame;
    }
}
- (void)setDataSource:(id<YPAdScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    CGSize pageControlSize = [pageControl sizeForNumberOfPages:[self.dataSource numberOfViewsInAdScrollView:self]];
    CGRect frame = pageControl.frame;
    frame.size = pageControlSize;
    pageControl.frame = frame;
}

- (void)setInterval:(CGFloat)interval {
    _interval = interval;
    if (interval != 0 && [self.dataSource numberOfViewsInAdScrollView:self]>2
        ) {
        self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}





@end
