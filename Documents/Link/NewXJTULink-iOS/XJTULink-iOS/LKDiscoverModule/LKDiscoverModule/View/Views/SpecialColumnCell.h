//
//  SpecialColumnCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialColumnModel.h"
static CGFloat const SpecialColumnCellHeight = 90;
@class SpecialColumnCell;

@protocol SpecialColumnDelegate <NSObject>
- (void)specialColumn:(SpecialColumnCell *)cell didTapIndex:(NSInteger)index;
@end

@interface SpecialColumnCell : UITableViewCell
@property (nonatomic, strong) SpecialColumnModel *viewModel;
@property (nonatomic, weak) id<SpecialColumnDelegate> delegate;
@end
