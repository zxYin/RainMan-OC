//
//  YLTableViewManager.h
//  YLTableViewManager
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kYLTableViewManagerKey;
extern NSString * const kYLTableViewManagerSectionHeader;
extern NSString * const kYLTableViewManagerSectionFooter;
extern NSString * const kYLTableViewManagerCellGenerator;
extern NSString * const kYLTableViewManagerCellHeight;
extern NSString * const kYLTableViewManagerCellCallback;

@protocol YLTableViewManagerDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSectionKey:(NSString *)key;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSectionKey:(NSString *)key;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionKey:(NSString *)key;
@end


typedef void (^YLTableViewManagerCellCallback)(UITableView *tableView, NSIndexPath *indexPath, id cell);
typedef UIView * (^YLTableViewManagerViewGenerator)(UITableView *tableView);
typedef UITableViewCell * (^YLTableViewManagerCellGenerator)(UITableView *tableView, NSIndexPath *indexPath,id cell);
typedef UIView * (^YLTableViewManagerHeaderGenerator)(UITableView *tableView, NSString *key);
typedef void (^YLTableViewManagerHeaderCallback)(UITableView *tableView, NSString *key, UIView *header);


@interface YLTableViewManager : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic, readonly) NSMutableDictionary *optionItems;
@property (strong, nonatomic, readonly) NSMutableArray<NSString *> *orderedKeys;

@property (nonatomic, weak) id<YLTableViewManagerDelegate> delegate;

- (void)registerSectionHeader:(YLTableViewManagerHeaderGenerator)generator
                     didClick:(YLTableViewManagerHeaderCallback) block;


// nib
- (void)registerSectionWithKey:(NSString *)key
                           nib:(NSString *)nibName
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block;

- (void)registerSectionWithKey:(NSString *)key
                           nib:(NSString *)nibName
                        header:(YLTableViewManagerViewGenerator)header
                        footer:(YLTableViewManagerViewGenerator)footer
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block;


// class
- (void)registerSectionWithKey:(NSString *)key
                         class:(Class)clazz
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block;


- (void)registerSectionWithKey:(NSString *)key
                         class:(Class)clazz
                        header:(YLTableViewManagerViewGenerator)header
                        footer:(YLTableViewManagerViewGenerator)footer
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block;

- (void)updateSectionByKey:(NSString *)key;
- (void)updateSectionByKey:(NSString *)key withRowAnimation:(UITableViewRowAnimation)animation;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)clearSections;

@end
