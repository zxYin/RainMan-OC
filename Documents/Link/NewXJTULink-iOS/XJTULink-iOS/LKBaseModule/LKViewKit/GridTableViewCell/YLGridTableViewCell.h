//
//  YLGridTableViewCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kYLGridItemImage;
extern NSString *const kYLGridItemTitle;
extern NSString *const kYLGridItemTintColor;

extern NSString *const YLGridTableViewCellIdentifier;
@protocol YLGridTableViewCellDeleagte <NSObject>
- (void)gridItemDidClickAtIndex:(NSInteger)index;
@end

@interface YLGridTableViewCell : UITableViewCell
@property (nonatomic, weak) id<YLGridTableViewCellDeleagte> delegate;

@property (nonatomic, copy) NSArray<NSDictionary *> *items;

@property (nonatomic, assign) NSInteger columnCount;
@end
