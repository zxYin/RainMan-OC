//
//  YLAlertPanel.h
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAlertPanelLine.h"
@interface YLIndexPath
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger line;
@end


@protocol YLAlertPanelDelegate, YLAlertPanelDataSource;
@interface YLAlertPanel : UIViewController
@property (nonatomic, copy) void (^completion)();

- (instancetype)initWithTitle:(NSString *)title;

- (NSInteger)addButtonWithTitle:(NSString *)title atLine:(NSInteger)line handler:(void (^)(YLAlertPanelButton *button))handler;
- (NSInteger)addLine:(YLAlertPanelLine *)line;

- (void)show;

- (void)dismiss;
- (void)dismissWithCompletion:(void (^)())completion;
+ (YLAlertPanel *)currentPanel;
@end


@protocol YLAlertPanelDelegate <NSObject>
- (void)alertPanel:(YLAlertPanel *)alertPanel clickedButtonAtIndexPath:(YLIndexPath *)indexPath;
- (void)willPresentAlertPanel:(YLAlertPanel *)alertPanel;
- (void)didPresentAlertPanel:(YLAlertPanel *)alertPanel;
@end

@protocol YLAlertPanelDataSource <NSObject>
- (NSInteger)numberOfSectionsInAlertPanel:(YLAlertPanel *)alertPanel;
- (NSInteger)alertPanel:(YLAlertPanel *)alertPanel numberOfItemsAtLine:(NSInteger)section;
- (UIView *)alertPanel:(YLAlertPanel *)alertPanel buttonForLineAtIndexPath:(YLIndexPath *)indexPath;
@end
