//
//  DiscoverHeadlineCell.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadlineModel.h"
#define DiscoverHeadlineCellHeight (CGRectGetWidth([UIScreen mainScreen].bounds) * 9 / 16)

@class DiscoverHeadlineCell;
@protocol DiscoverHeadlineCellDelegate <NSObject>
- (void)discoverHeadlineCell:(DiscoverHeadlineCell *)cell didTapViewAtIndex:(NSInteger)index;
@end


@interface DiscoverHeadlineCell : UITableViewCell
@property (nonatomic, strong) NSArray<HeadlineModel *> *viewModels;
@property (nonatomic, weak) id<DiscoverHeadlineCellDelegate> delegate;
@end
