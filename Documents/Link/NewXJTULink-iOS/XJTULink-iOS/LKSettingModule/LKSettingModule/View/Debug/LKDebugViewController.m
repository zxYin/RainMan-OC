//
//  LKDebugViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKDebugViewController.h"
#import "LKToggleSwitchCell.h"
#import "ViewsConfig.h"
#import "Macros.h"
#import "FLEXManager.h"
#import "NSUserDefaults+LKTools.h"
#import "User+Auth.h"
#import "LKDebugItemPickerViewController.h"
#import "Foundation+LKTools.h"
#import "JPFPSStatus.h"

#define LKUserDefaultsKeyServerURL [@"link.xjtu.debug.serverURL" md5String]


typedef void (^LKDebugNormalItemBlock)();
typedef void (^LKDebugSwitchItemBlock)(BOOL enable);

typedef NS_ENUM(NSInteger, DebugItemType) {
    kDebugItemTypeDefault,
    kDebugItemTypeSubtitle,
    kDebugItemTypeSwitch,
};

static NSString * const kDebugItemKeyTitle = @"kDebugItemKeyTitle";
static NSString * const kDebugItemKeySubtitle = @"kDebugItemKeySubtitle";
static NSString * const kDebugItemKeyType = @"kDebugItemKeyType";
static NSString * const kDebugItemKeyBlock = @"kDebugItemKeyBlock";
static NSString * const kDebugItemKeyUserDefaults = @"kDebugItemKeyUserDefaults";
static NSString * const kDebugItemKeyUserDefaultsDefaultValue = @"kDebugItemKeyUserDefaultsDefaultValue";
static NSString * const kDebugItemKeyExtra = @"kDebugItemKeyExtra";

@interface LKDebugViewController ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation LKDebugViewController
#define LKDebugAddItem()

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调试选项";
    [self setup];
    
    self.tableView.tableFooterView = [UIView new];
    UINib *nib = [UINib nibWithNibName:@"LKToggleSwitchCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[LKToggleSwitchCell lk_identifier]];

}
#pragma mark - setup
- (void)setup {
    @weakify(self);
    NSString *userId = [User sharedInstance].userId;
    [self addMutiTextItemWithTitle:@"User ID" subtitle:userId block:nil];
    
    NSString *userToken = [User sharedInstance].unencryptedRequestToken;
    [self addMutiTextItemWithTitle:@"User Token" subtitle:userToken block:^{
        @strongify(self);
        [self showCopyAlertWithText:userToken];
    }];
    
    NSString *deviceToken = [LKUserDefaults objectForKey:LKUserDefaultsDeviceToken];
    [self addMutiTextItemWithTitle:@"Device Token" subtitle:deviceToken block:^{
        @strongify(self);
        [self showCopyAlertWithText:deviceToken];
    }];
    
    [self addItemWithTitle:@"选择服务器" block:^{
        NSLog(@"点击选择服务器");
        @strongify(self);
        NSMutableArray *servers = [NSMutableArray arrayWithArray: [LKUserDefaults arrayForKey:LKUserDefaultsKeyServerURL]];
        if (![servers containsObject:kLinkDefaultServerURL]) {
            [servers insertObject:kLinkDefaultServerURL atIndex:0];
            [LKUserDefaults setObject:[servers copy] forKey:LKUserDefaultsKeyServerURL];
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [LKUserDefaults setObject:kLinkDefaultServerURL forKey:[LKUserDefaultsKeyServerURL debug_selectedKey]];
        });
        
        LKDebugItemPickerViewController *vc = [[LKDebugItemPickerViewController alloc] initWithUserDefaultsKey:LKUserDefaultsKeyServerURL block:^(NSString *item) {
            if([NSString notBlank:item]) {
                __CHANGE_SERVER_URL(item);
            }
        }];
        vc.title = @"选择服务器";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self addItemWithTitle:@"开启FLEX" block:^{
        [[FLEXManager sharedManager] showExplorer];
    }];
    
#ifdef DEBUG
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self addItemWithTitle:@"查看JSPatch" block:^{
        id clazz = NSClassFromString(@"BAJPPF");
        [clazz performSelector:@selector(presentDebugViewController)];
    }];
#pragma clang diagnostic pop
#endif
    
    [self addSwitchItemWithTitle:@"FPS" userDefault:LKUserDefaultsFPS defaultValue:NO block:^(BOOL enable) {
        if(enable) {
            [[JPFPSStatus sharedInstance] open];
        } else {
            [[JPFPSStatus sharedInstance] close];
        }
    }];

    
    [self addSwitchItemWithTitle:@"强制登录" userDefault:LKUserDefaultsForceLogin defaultValue:YES block:^(BOOL enable) {
        
    }];
    
    [self addItemWithTitle:@"强制Crash" block:^{
        NSLog(@"Crash");
        @strongify(self);
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ Crash",[self class]]
                                       reason:@"强制Crash"
                                     userInfo:nil];
    }];
    
    [self addItemWithTitle:@"重置引导页" block:^{
        [AppContext showProgressFinishHUDWithMessage:@"引导页已重置"];
    }];
    
}

- (void)showCopyAlertWithText:(NSString *)text {
    TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
    actionSheet.title = [NSString stringWithFormat:@"%@",text];
    [actionSheet addButtonWithTitle:@"复制"style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        [UIPasteboard generalPasteboard].string = text;
        [AppContext showProgressFinishHUDWithMessage:@"复制成功"];
    }];
    
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSDictionary *item = self.items[indexPath.row];
    switch ([item[kDebugItemKeyType] integerValue]) {
        case kDebugItemTypeDefault: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
            if(cell == nil) {
                cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"default"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = item[kDebugItemKeyTitle];
            
            break;
        }
        case kDebugItemTypeSubtitle: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"subtitle"];
            if(cell == nil) {
                cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"subtitle"];
            }
            cell.textLabel.text = item[kDebugItemKeyTitle];
            cell.detailTextLabel.text = item[kDebugItemKeySubtitle];
            break;
        }
            
        case kDebugItemTypeSwitch: {
            cell = [tableView dequeueReusableCellWithIdentifier:[LKToggleSwitchCell lk_identifier] forIndexPath:indexPath];
            LKToggleSwitchCell *switchCell = (LKToggleSwitchCell *)cell;
            NSString *key = item[kDebugItemKeyUserDefaults];
            if (key) {
                id defaultValue = item[kDebugItemKeyUserDefaultsDefaultValue];
                BOOL on = [LKUserDefaults boolForKey:key defaultValue:[defaultValue boolValue]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                switchCell.toggleSwitch.on = on;
            }
        
            
            [[switchCell.toggleSwitch.rac_newOnChannel
              takeUntil:switchCell.rac_prepareForReuseSignal]
              subscribeNext:^(id x) {
                NSLog(@"%@ Switch 切换", key);
                BOOL result = [x boolValue];
                [LKUserDefaults setBool:result forKey:key];
                if (item[kDebugItemKeyBlock]) {
                    ((LKDebugSwitchItemBlock)item[kDebugItemKeyBlock])([x boolValue]);
                }
            }];
            switchCell.titleLabel.text = item[kDebugItemKeyTitle];
            
            break;
        }
        default:
            break;
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.items[indexPath.row];
    switch ([item[kDebugItemKeyType] integerValue]) {
        case kDebugItemTypeDefault:
        case kDebugItemTypeSubtitle: {
            if (item[kDebugItemKeyBlock]) {
                ((LKDebugNormalItemBlock)item[kDebugItemKeyBlock])();
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -

- (void)addItemWithTitle:(NSString *)title block:(LKDebugNormalItemBlock)block{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[kDebugItemKeyTitle] = title;
    item[kDebugItemKeyBlock] = block;
    item[kDebugItemKeyType] = @(kDebugItemTypeDefault);
    [self.items addObject:item];
}

- (void)addMutiTextItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle block:(LKDebugNormalItemBlock)block{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[kDebugItemKeyTitle] = title;
    item[kDebugItemKeySubtitle] = subtitle;
    item[kDebugItemKeyBlock] = block;
    item[kDebugItemKeyType] = @(kDebugItemTypeSubtitle);
    [self.items addObject:item];
}


- (void)addSwitchItemWithTitle:(NSString *)title block:(LKDebugSwitchItemBlock)block {
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[kDebugItemKeyTitle] = title;
    item[kDebugItemKeyType] = @(kDebugItemTypeSwitch);
    item[kDebugItemKeyBlock] = block;
    [self.items addObject:item];
}

- (void)addSwitchItemWithTitle:(NSString *)title userDefault:(NSString *)key defaultValue:(BOOL)defaultValue block:(LKDebugSwitchItemBlock)block {
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    item[kDebugItemKeyTitle] = title;
    item[kDebugItemKeyType] = @(kDebugItemTypeSwitch);
    item[kDebugItemKeyUserDefaults] = key;
    item[kDebugItemKeyUserDefaultsDefaultValue] = @(defaultValue);
    item[kDebugItemKeyBlock] = block;
    [self.items addObject:item];
    
}

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

@end
