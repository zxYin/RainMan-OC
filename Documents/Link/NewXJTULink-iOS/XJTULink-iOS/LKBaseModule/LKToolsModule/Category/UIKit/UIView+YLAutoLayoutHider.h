//
//  UIView+YLAutoLayoutHider.h
//  YLAutoLayoutHider
//
//  Created by Yunpeng on 2017/3/31.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YLPositionMode) {
    YLPositionModeReplace,
    YLPositionModeElimination,
    YLPositionModeTotal,
};

typedef NS_OPTIONS(NSInteger, YLHiddenType) {
    YLHiddenTypeNone        = 0,
    YLHiddenTypeVertical    = 1 << 0,
    YLHiddenTypeHorizontal  = 1 << 1,
    YLHiddenTypeEntirely    = 1 << 2,
};

@interface UIView (YLAutoLayoutHider)
- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type;
- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type mode:(YLPositionMode)mode;

- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type zero:(CGFloat)zero;
- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type mode:(YLPositionMode)mode zero:(CGFloat)zero;
@end

