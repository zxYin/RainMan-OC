//
//  YLTableViewManager.m
//  YLTableViewManager
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLTableViewManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>

NSString * const kYLTableViewManagerKey             = @"kTableViewManagerKey";
NSString * const kYLTableViewManagerSectionHeader   = @"kYLTableViewManagerSectionHeader";
NSString * const kYLTableViewManagerSectionFooter   = @"kYLTableViewManagerSectionFooter";
NSString * const kYLTableViewManagerCellIdentifier  = @"kYLTableViewManagerCellIdentifier";
NSString * const kYLTableViewManagerCellGenerator   = @"kTableViewManagerCellBlock";
NSString * const kYLTableViewManagerCellHeight      = @"kTableViewManagerCellHeight";
NSString * const kYLTableViewManagerCellCallback    = @"kTableViewManagerCallbackBlock";

@interface YLTableViewManager()
@property (strong, nonatomic) NSMutableDictionary *optionItems;
@property (strong, nonatomic) NSMutableArray<NSString *> *orderedKeys;
@property (copy, nonatomic) YLTableViewManagerHeaderGenerator headerGenerator;
@property (copy, nonatomic) YLTableViewManagerHeaderCallback headerCallback;

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation YLTableViewManager

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.optionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSectionKey:)]) {
        return [self.delegate tableView:tableView numberOfRowsInSectionKey:self.orderedKeys[section]];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSectionKey:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSectionKey:self.orderedKeys[section]];
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSectionKey:)]) {
        
        return [self.delegate tableView:tableView heightForFooterInSectionKey:self.orderedKeys[section]];
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    NSString *key = self.orderedKeys[section];
    YLTableViewManagerViewGenerator generator = self.optionItems[key][kYLTableViewManagerSectionHeader];
    if (generator) {
        header = generator(tableView);
    } else if(self.headerGenerator){
        header = self.headerGenerator(self.tableView, key);
        if (self.headerCallback) {
            [header bk_whenTapped:^{
                if (self.headerCallback) {
                    self.headerCallback(self.tableView, key, header);
                }
            }];
        }
        
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *key = self.orderedKeys[section];
    YLTableViewManagerViewGenerator generator = self.optionItems[key][kYLTableViewManagerSectionFooter];
    return generator?generator(tableView):nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.orderedKeys[indexPath.section];
    return [self.optionItems[key][kYLTableViewManagerCellHeight] doubleValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.orderedKeys[indexPath.section];
    YLTableViewManagerCellGenerator generator = self.optionItems[key][kYLTableViewManagerCellGenerator];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.optionItems[key][kYLTableViewManagerCellIdentifier] forIndexPath:indexPath];
    return generator?generator(tableView,indexPath, cell):nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSString *key = self.orderedKeys[indexPath.section];
    YLTableViewManagerCellCallback blk = self.optionItems[key][kYLTableViewManagerCellCallback];
    if (blk) {
        id cell = [tableView cellForRowAtIndexPath:indexPath];
        blk(tableView, indexPath, cell);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - Public API

- (void)registerSectionHeader:(YLTableViewManagerHeaderGenerator)generator
                     didClick:(YLTableViewManagerHeaderCallback)block {
    self.headerGenerator = generator;
    self.headerCallback = block;
    
}

- (void)registerSectionWithKey:(NSString *)key
                           nib:(NSString *)nibName
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block {
    [self registerSectionWithKey:key
                             nib:nibName
                          header:nil
                          footer:nil
                            cell:generator
                          height:height
                        didClick:block];
}


- (void)registerSectionWithKey:(NSString *)key
                           nib:(NSString *)nibName
                        header:(YLTableViewManagerViewGenerator)header
                        footer:(YLTableViewManagerViewGenerator)footer
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block {
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:nibName];
    
    [self registerSectionWithKey:key
                      identifier:nibName
                          header:header
                          footer:footer
                            cell:generator
                          height:height
                        didClick:block];
}



- (void)registerSectionWithKey:(NSString *)key
                         class:(Class)clazz
                          cell:(nonnull YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(nullable YLTableViewManagerCellCallback)block {
    [self registerSectionWithKey:key
                           class:clazz
                          header:nil
                          footer:nil
                            cell:generator
                          height:height
                        didClick:block];
}

- (void)registerSectionWithKey:(NSString *)key
                         class:(Class)clazz
                        header:(YLTableViewManagerViewGenerator)header
                        footer:(YLTableViewManagerViewGenerator)footer
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block {
    NSString *identifier = NSStringFromClass(clazz);
    [self.tableView registerClass:clazz forCellReuseIdentifier:identifier];
    
    [self registerSectionWithKey:key
                      identifier:identifier
                          header:header
                          footer:footer
                            cell:generator
                          height:height
                        didClick:block];
}


- (void)registerSectionWithKey:(NSString *)key
                    identifier:(NSString *)identifier
                        header:(YLTableViewManagerViewGenerator)header
                        footer:(YLTableViewManagerViewGenerator)footer
                          cell:(YLTableViewManagerCellGenerator)generator
                        height:(CGFloat)height
                      didClick:(YLTableViewManagerCellCallback)block {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kYLTableViewManagerKey] = key;
    dict[kYLTableViewManagerSectionHeader] = header;
    dict[kYLTableViewManagerSectionFooter] = footer;
    dict[kYLTableViewManagerCellHeight] = @(height);
    dict[kYLTableViewManagerCellGenerator] = generator;
    dict[kYLTableViewManagerCellCallback] = block;
    dict[kYLTableViewManagerCellIdentifier] = identifier;
    
    [self.optionItems setObject:[dict copy] forKey:key];
    [self.orderedKeys addObject:key];
}

- (void)updateSectionByKey:(NSString *)key {
    [self updateSectionByKey:key withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateSectionByKey:(NSString *)key
          withRowAnimation:(UITableViewRowAnimation)animation {
    NSInteger index = [self.orderedKeys indexOfObject:key];
    if (index == NSNotFound) {
        return;
    }
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:indexSet
                      withRowAnimation:animation];
    });
}

- (void)clearSections {
    self.optionItems = nil;
    self.orderedKeys = nil;
    [self.tableView reloadData];
}

#pragma mark - Private API
- (void)header:(UIView *)header didClick:(YLTableViewManagerHeaderCallback)block {
    
}

#pragma mark - getter
- (NSMutableDictionary *)optionItems {
    if (_optionItems == nil) {
        _optionItems = [[NSMutableDictionary alloc] init];
    }
    return _optionItems;
}

- (NSMutableArray<NSString *> *)orderedKeys {
    if (_orderedKeys == nil) {
        _orderedKeys = [[NSMutableArray alloc] init];
    }
    return _orderedKeys;
}
@end
