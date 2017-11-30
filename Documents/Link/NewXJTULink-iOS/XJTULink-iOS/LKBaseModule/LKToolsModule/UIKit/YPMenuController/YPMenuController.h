//
//  WeekMenuController.h
//  MenuTest
//
//  Created by Yunpeng on 16/4/23.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickEvent)(NSInteger index);

@interface YPMenuController : UIViewController
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIColor *highlightedCellColor;
@property (assign,nonatomic,getter=isHidden) BOOL hidden;
@property (copy,nonatomic) ClickEvent clickEventBlock;
@property (copy,nonatomic) NSArray<NSString *> *items;

- (instancetype)initWithBlock:(ClickEvent)block;
- (instancetype)initWithBlock:(ClickEvent)block initialSelections:(NSInteger)index;

- (void)selectIndex:(NSInteger)index;
@end
