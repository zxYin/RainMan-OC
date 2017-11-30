//
//  UIView+YLAutoLayoutHider.m
//  YLAutoLayoutHider
//
//  Created by Yunpeng on 2017/3/31.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "UIView+YLAutoLayoutHider.h"
#import <objc/runtime.h>

@interface NSArray(_YLLayoutConstraint)

@end

@implementation NSArray(_YLLayoutConstraint)
- (NSArray<NSLayoutConstraint *> *)constraintsForFirstAttribute:(NSLayoutAttribute)firstAttribute firstItem:(id)firstItem {
    return [self constraintsForPredicate:[NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", firstAttribute, firstItem]];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForSecondAttribute:(NSLayoutAttribute)secondAttribute secondItem:(id)secondItem {
    return [self constraintsForPredicate:[NSPredicate predicateWithFormat:@"secondAttribute = %d && secondItem = %@", secondAttribute, secondItem]];
}


- (NSArray<NSLayoutConstraint *> *)constraintForFirstAttribute:(NSLayoutAttribute)firstAttribute firstItem:(id)firstItem secondAttribute:(NSLayoutAttribute)secondAttribute secondItem:(id)secondItem  {
    return [self constraintsForPredicate:[NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@ && secondAttribute = %d && secondItem = %@",firstAttribute, firstItem, secondAttribute, secondItem]];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForPredicate:(NSPredicate *)predicate {
    NSArray *fillteredArray = [self filteredArrayUsingPredicate:predicate];
    if(fillteredArray.count == 0) {
        return nil;
    } else {
        return fillteredArray;
    }
}

@end

#define YLOriginalInfoKey(ATTR, ITEM) [NSString stringWithFormat:@"%td_%td",(ITEM).hash, (ATTR)]

@interface UIView(_YLAutoLayoutHider)
@property (nonatomic, strong, readonly) NSMutableDictionary *originalInfo;
@end

@implementation UIView(_YLAutoLayoutHider)
- (NSMutableDictionary *)originalInfo {
    NSMutableDictionary *originalInfo = objc_getAssociatedObject(self, _cmd);
    if (originalInfo == nil) {
        originalInfo = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, originalInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return originalInfo;
}
@end

@implementation UIView (YLAutoLayoutHider)
#pragma mark - Public API
- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type {
    [self yl_setHidden:hidden forType:type zero:0];
}

- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type zero:(CGFloat)zero {
    [self yl_setHidden:hidden forType:type mode:YLPositionModeReplace zero:zero];
}

- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type mode:(YLPositionMode)mode {
    [self yl_setHidden:hidden forType:type mode:mode zero:0];
}

- (void)yl_setHidden:(BOOL)hidden forType:(YLHiddenType)type mode:(YLPositionMode)mode zero:(CGFloat)zero {
    if (hidden == self.hidden) {
        return;
    }
    
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    NSArray<NSLayoutConstraint *> *positionConstraints = nil;
    
    if (type & YLHiddenTypeVertical
        || type & YLHiddenTypeEntirely) {
        
        NSLayoutConstraint *heightConstraint =
        [[self.constraints constraintsForFirstAttribute:NSLayoutAttributeHeight firstItem:self] lastObject];
        [self updateConstraint:heightConstraint attribute:NSLayoutAttributeHeight item:self hidden:hidden zero:zero];
        
        switch (mode) {
            case YLPositionModeReplace:
                // 获取以自身bottom有关的constraint
                positionConstraints = [self.superview.constraints constraintsForSecondAttribute:NSLayoutAttributeBottom secondItem:self];
                attribute = NSLayoutAttributeBottom;
                break;
            case YLPositionModeElimination:
                // 获取自身top
                positionConstraints = [self.superview.constraints constraintsForFirstAttribute:NSLayoutAttributeTop firstItem:self];
                attribute = NSLayoutAttributeTop;
                break;
            case YLPositionModeTotal:
                break;
            default:
                break;
        }
        
        if (positionConstraints.count > 0) {
            [positionConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat zero = 0;
                
                if (idx == 0) {
                    NSLayoutConstraint *centerYConstraint =
                    [[self.superview.constraints constraintsForFirstAttribute:NSLayoutAttributeCenterY firstItem:self] firstObject];
                    if (centerYConstraint) {
                        NSLayoutConstraint *heightConstraint =
                        [[((UIView *)constraint.firstItem).constraints constraintsForFirstAttribute:NSLayoutAttributeHeight firstItem:constraint.firstItem] firstObject];
                        zero = - heightConstraint.constant / 2.0;
                    }
                }
                
                [self updateConstraint:constraint attribute:attribute item:constraint.secondItem hidden:hidden zero:zero];
            }];
        }
    }
    
    if (type & YLHiddenTypeHorizontal
        || type & YLHiddenTypeEntirely) {
        NSLayoutConstraint *widthConstraint =
        [[self.constraints constraintsForFirstAttribute:NSLayoutAttributeWidth firstItem:self] lastObject];
        [self updateConstraint:widthConstraint attribute:NSLayoutAttributeWidth item:self hidden:hidden zero:zero];
        
        switch (mode) {
            case YLPositionModeReplace:
                // 获取以自身trailing有关的constraint
                positionConstraints = [self.superview.constraints constraintsForSecondAttribute:NSLayoutAttributeTrailing secondItem:self];
                attribute = NSLayoutAttributeTrailing;
                break;
            case YLPositionModeElimination:
                // 获取自身leading
                positionConstraints = [self.superview.constraints constraintsForFirstAttribute:NSLayoutAttributeLeading firstItem:self];
                attribute = NSLayoutAttributeLeading;
                break;
            case YLPositionModeTotal:
                break;
            default:
                break;
        }
        
        if (positionConstraints.count > 0) {
            [positionConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat zero = 0;
                
                if (idx == 0) {
                    NSLayoutConstraint *centerXConstraint =
                    [[self.superview.constraints constraintsForFirstAttribute:NSLayoutAttributeCenterX firstItem:self] firstObject];
                    if (centerXConstraint) {
                        NSLayoutConstraint *widthConstraint =
                        [[((UIView *)constraint.firstItem).constraints constraintsForFirstAttribute:NSLayoutAttributeWidth firstItem:constraint.firstItem] firstObject];
                        zero = - widthConstraint.constant / 2.0;
                    }
                }
                
                [self updateConstraint:constraint attribute:attribute item:constraint.secondItem hidden:hidden zero:zero];
            }];
        }
    }
    
    self.hidden = hidden;
    [self.superview updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
}

#pragma mark - Private API
- (void)updateConstraint:(NSLayoutConstraint *)constraint attribute:(NSLayoutAttribute)attribute item:(NSObject *)item hidden:(BOOL)hidden {
    [self updateConstraint:constraint attribute:attribute item:item hidden:hidden zero:0];
}

- (void)updateConstraint:(NSLayoutConstraint *)constraint attribute:(NSLayoutAttribute)attribute item:(NSObject *)item hidden:(BOOL)hidden zero:(CGFloat)zero {
    if (constraint) {
        if (hidden) {
            self.originalInfo[YLOriginalInfoKey(attribute, item)] = @(constraint.constant);
            constraint.constant = zero;
        } else {
            if (self.originalInfo[YLOriginalInfoKey(attribute, item)]) {
                constraint.constant =
                [self.originalInfo[YLOriginalInfoKey(attribute, item)] floatValue];
            }
        }
    }
}
@end

