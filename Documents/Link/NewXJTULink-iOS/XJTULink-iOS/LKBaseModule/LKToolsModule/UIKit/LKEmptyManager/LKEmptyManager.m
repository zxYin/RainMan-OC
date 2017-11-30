//
//  LKEmptyManager.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKEmptyManager.h"
#import "MJRefresh.h"
#import "Foundation+LKTools.h"

NSString * const kLKEmptyManagerDefaultContent1 = @"没找到数据耶，真尴尬！";
NSString * const kLKEmptyManagerDefaultContent2 = @"没找到数据耶，真尴尬！\n(点击再试一下)";
@interface LKEmptyManager() <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *originColor;

@end
@implementation LKEmptyManager
- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.autoRefresh = YES;
        self.displayEnable = YES;
        self.allowTouch = YES;
        self.forcedToDisplay = NO;
        self.scrollView = scrollView;
        scrollView.emptyDataSetSource = self;
        scrollView.emptyDataSetDelegate = self;
        self.originColor = scrollView.backgroundColor;
    }
    return self;
}
#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NSString isBlank:self.title]) {
        return nil;
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                 };
    
    return [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NSString isBlank:self.content]) {
        return nil;
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:self.content attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.backgroundColor?:[UIColor whiteColor];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.displayEnable;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return self.allowTouch;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.scrollView.backgroundColor = self.backgroundColor;
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView {
    self.scrollView.backgroundColor = self.originColor;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return self.forcedToDisplay;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if ([self.delegate respondsToSelector:@selector(emptyManager:didTapView:)]) {
        [self.delegate emptyManager:self didTapView:view];
    } else {
        if(self.autoRefresh && [self.scrollView.mj_header respondsToSelector:@selector(beginRefreshing)]) {
            [self.scrollView.mj_header beginRefreshing];
        }
    }
}

- (void)reloadEmptyDataSet {
    [self.scrollView reloadEmptyDataSet];
}

+ (instancetype)defaultEmptyManagerWithScrollView:(UIScrollView *)scrollView {
    return [self defaultEmptyManagerWithScrollView:scrollView style:LKEmptyManagerStyleCustom];
}

+ (instancetype)defaultEmptyManagerWithScrollView:(UIScrollView *)scrollView style:(LKEmptyManagerStyle)style {
    LKEmptyManager *manager = [[LKEmptyManager alloc] initWithScrollView:scrollView];
    manager.backgroundColor = LKEmptyManagerBackgroundColorDefault;

    switch (style) {
        case LKEmptyManagerStylePreview:
            manager.image = [UIImage imageNamed:@"image_preview"];
            break;
        case LKEmptyManagerStyleNoData: {
            manager.image = [UIImage imageNamed:@"image_empty_data"];
            manager.title = @"Oops...";
            manager.content = kLKEmptyManagerDefaultContent2;
            break;
        }
        default:
            break;
    }
    
    return manager;
}

- (void)setAllowTouch:(BOOL)allowTouch {
    _allowTouch = allowTouch;
    if (allowTouch &&
        [self.content isEqualToString:kLKEmptyManagerDefaultContent1]) {
        self.content = kLKEmptyManagerDefaultContent2;
    } else if (!allowTouch && [self.content isEqualToString:kLKEmptyManagerDefaultContent2]) {
        self.content = kLKEmptyManagerDefaultContent1;
    }
}

@end
