//
//  DiscoverAdCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPAdScrollView.h"
#import "HeadlineModel.h"

#define DiscoverAdCellHeight (CGRectGetWidth([UIScreen mainScreen].bounds) * 9 / 16)

@class DiscoverAdCell;
@protocol DiscoverAdCellDelegate <NSObject>
- (void)discoverAdCell:(DiscoverAdCell *)cell didTapViewAtIndex:(NSInteger)index;
- (NSInteger)discoverAdCellintervalOfCarousel;
@end

extern NSString *const DiscoverAdCellHeightIdentifier;
@interface DiscoverAdCell : UITableViewCell<YPAdScrollViewDataSource,YPAdScrollViewDelegate>
@property (nonatomic, assign) NSInteger visiableIndex;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray<HeadlineModel *> *viewModels;
@property (nonatomic, weak) id<DiscoverAdCellDelegate> delegate;
@end
