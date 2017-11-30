//
//  YLAlertPanelButton.h
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YLAlertPanelButtonHeight (64 + 20)
#define YLAlertPanelButtonWidth 64

@interface YLAlertPanelButton : UIView
@property (nonatomic, copy) UIColor *highlightColor;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image;
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(YLAlertPanelButton *button))handler;
@end
