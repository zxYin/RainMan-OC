//
//  LKFakeNavigationController.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKFakeNavigationController.h"
#import <objc/runtime.h>
#import "UINavigationBar+Awesome.h"
#import "Aspects.h"
@interface LKFakeNavigationController()
@property (nonatomic, strong) UINavigationItem *titleNavigationItem;
@end

@implementation LKFakeNavigationController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.navigationBar];
        self.backgroundColor = self.navigationBar.backgroundColor;
        [self.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleNavigationItem.title = title;
}

- (UINavigationBar *)navigationBar {
    if (_navigationBar == nil) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:self.frame];
        [_navigationBar pushNavigationItem:self.titleNavigationItem animated:NO];
    }
    return _navigationBar;
}


- (UINavigationItem *)titleNavigationItem {
    if (_titleNavigationItem == nil) {
        _titleNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    }
    return _titleNavigationItem;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
//    if (!hidden) {
//        
//    }
    
}

@end


@implementation UIViewController (LKFakeNavigationController)

- (LKFakeNavigationController *)lk_fakeNavigationController {
    LKFakeNavigationController *fakeNC = objc_getAssociatedObject(self, _cmd);
    if (fakeNC == nil) {
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        CGRect frame = statusBarFrame;
        frame.size.height +=
        MAX(CGRectGetHeight(self.navigationController.navigationBar.frame),44);
        fakeNC = [[LKFakeNavigationController alloc] initWithFrame:frame];
        
        [self.view addSubview:fakeNC];
        [self.view bringSubviewToFront:fakeNC];
        
        [self.view aspect_hookSelector:@selector(addSubview:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            [aspectInfo.instance bringSubviewToFront:fakeNC];
        } error:NULL];
        
        fakeNC.hidden = YES;
        
        objc_setAssociatedObject(self, _cmd, fakeNC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return fakeNC;
}

@end


