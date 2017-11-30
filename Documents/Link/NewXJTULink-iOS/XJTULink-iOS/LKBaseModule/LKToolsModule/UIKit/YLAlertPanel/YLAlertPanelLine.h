//
//  YLAlertPanelLine.h
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAlertPanelButton.h"
#define YLAlertPanelLineHeight 124
@interface YLAlertPanelLine : UITableViewCell
@property (nonatomic, assign) NSUInteger countOfButtons;
@property (nonatomic, assign) UIEdgeInsets edges;

- (NSInteger)addButtonWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(YLAlertPanelButton *button))handler;
- (NSInteger)insertButtonWithTitle:(NSString *)title image:(UIImage *)image atIndex:(NSInteger)index handler:(void (^)(YLAlertPanelButton *button))handler;
@end
