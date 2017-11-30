//
//  LKDebugItemPickerViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKDebugItemPickerViewController.h"
#import "NSUserDefaults+LKTools.h"
#import "Macros.h"
#import "ViewsConfig.h"
#import "Foundation+LKTools.h"
#import "MGSwipeTableCell.h"
NSString * const NSUserDefaultsKeyDebugSelectedTag = @"__debug_selected";

@implementation NSString (LKDebugItemPickerViewController)
- (NSString *)debug_selectedKey {
    NSString *selectedKey = [self stringByAppendingString:NSUserDefaultsKeyDebugSelectedTag];
    return [selectedKey md5String];
}


@end


@interface LKDebugItemPickerViewController()
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSMutableArray *items;
@property (nonatomic, copy) NSString *selectedItem;
@property (nonatomic, copy) LKDebugItemBlock block;
@end

@implementation LKDebugItemPickerViewController
@synthesize selectedItem = _selectedItem;

- (instancetype)initWithUserDefaultsKey:(NSString *)key block:(LKDebugItemBlock)block;{
    self = [super init];
    if (self) {
        self.key = key;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        @strongify(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加新选项" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"不可为空";
        }];

        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alertController.textFields.firstObject;
            NSString *item = textField.text;
            if ([NSString notBlank:item]) {
                [self.items addObject:item];
                [self.tableView reloadData];
                
                [LKUserDefaults setObject:[self.items copy] forKey:self.key];
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.block) {
        self.block(self.selectedItem);
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGSwipeTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"debugItem"];
    if (cell == nil) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"debugItem"];
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    NSString *item = self.items[indexPath.row];
    cell.textLabel.text = item;
    
    if ([item isEqualToString:self.selectedItem]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        return YES;
    }];
    cell.rightButtons = @[deleteButton];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *item = self.items[indexPath.row];
    if(![self.selectedItem isEqualToString:item]) {
        self.selectedItem = item;
        [tableView reloadData];
    }
    
}


- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray arrayWithArray: [LKUserDefaults arrayForKey:self.key]];
    }
    return _items;
}

- (NSString *)selectedItem {
    if (_selectedItem == nil) {
        _selectedItem = [LKUserDefaults stringForKey:[self.key debug_selectedKey]];
    }
    return _selectedItem;
}

- (void)setSelectedItem:(NSString *)selectedItem {
    if (![_selectedItem isEqualToString:selectedItem]) {
        _selectedItem = selectedItem;
        [LKUserDefaults setObject:selectedItem forKey:[self.key debug_selectedKey]];
    }
    
}

@end
