//
//  LKEmptyManager.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"
#define LKEmptyManagerWith(VIEW, STYLE) [LKEmptyManager defaultEmptyManagerWithScrollView:VIEW style:STYLE]
extern NSString * const kLKEmptyManagerDefaultContent1;
extern NSString * const kLKEmptyManagerDefaultContent2;
@class LKEmptyManager;

#define LKEmptyManagerBackgroundColorDefault [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

@protocol LKEmptyManagerDelegate <NSObject>
@optional
- (void)emptyManager:(LKEmptyManager *)manager didTapView:(UIView *)view;
@end

typedef NS_ENUM(NSInteger, LKEmptyManagerStyle) {
    LKEmptyManagerStylePreview,
    LKEmptyManagerStyleNoData,
    LKEmptyManagerStyleCustom,
};

@interface LKEmptyManager : NSObject

@property (nonatomic, assign) BOOL allowTouch;
@property (nonatomic, assign) BOOL displayEnable;
@property (nonatomic, assign) BOOL forcedToDisplay;
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) BOOL autoRefresh;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) UIColor *backgroundColor;
@property (nonatomic, weak) id<LKEmptyManagerDelegate> delegate;


- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)reloadEmptyDataSet;

+ (instancetype)defaultEmptyManagerWithScrollView:(UIScrollView *)scrollView;
+ (instancetype)defaultEmptyManagerWithScrollView:(UIScrollView *)scrollView style:(LKEmptyManagerStyle)style;
@end
