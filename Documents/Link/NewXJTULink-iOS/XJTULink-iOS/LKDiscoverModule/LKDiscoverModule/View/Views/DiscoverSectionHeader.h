//
//  DiscoverSectionHeader.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern const CGFloat DiscoverSectionHeaderHeight;
@interface DiscoverSectionHeader : UIView
@property (nonatomic, strong) UILabel *titleLabel;
+ (instancetype)discoverSectionHeaderWithTitle:(NSString *)title;
@end
