//
//  LKDebugItemPickerViewController.h
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const NSUserDefaultsKeyDebugSelectedTag;

@interface NSString (LKDebugItemPickerViewController)
- (NSString *)debug_selectedKey;
@end


typedef void (^LKDebugItemBlock)(NSString *item);
@interface LKDebugItemPickerViewController : UITableViewController
- (instancetype)initWithUserDefaultsKey:(NSString *)key block:(LKDebugItemBlock)block;
@end
