//
//  SpecialColumnView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialColumnModel.h"
static CGFloat const SpecialColumnViewHeight = 90;

@class SpecialColumnView;

@protocol SpecialColumnDelegate <NSObject>
- (void)specialColumn:(SpecialColumnView *)view didTapIndex:(NSInteger)index;
@end

@interface SpecialColumnView : UIView
@property (nonatomic, strong) SpecialColumnModel *viewModel;
@property (nonatomic, weak) id<SpecialColumnDelegate> delegate;
@end