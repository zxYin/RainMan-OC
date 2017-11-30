//
//  YLGridItemCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat YLGridItemCellHeight = 70;

extern NSString *const YLGridItemCellIdentifier;
@interface YLGridItemCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
