//
//  SpecialColumnItemView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleURLModel.h"
@interface SpecialColumnItemView : UIView
@property (nonatomic, copy) UILabel *tagLabel;
@property (nonatomic, copy) UILabel *titleLabel;

- (instancetype)initWithModel:(SingleURLModel *)model;
@end
