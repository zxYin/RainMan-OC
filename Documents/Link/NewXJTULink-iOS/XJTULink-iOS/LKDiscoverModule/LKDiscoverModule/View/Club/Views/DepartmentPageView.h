//
//  DepartmentPageView.h
//  DepartmentPageView
//
//  Created by Yunpeng on 16/7/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "DepartmentModel.h"
@interface DepartmentPageView : UIView
@property (nonatomic, assign) CGFloat leftHeight;
@property (nonatomic, assign) CGFloat rightHeight;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

- (instancetype)initWithModel:(DepartmentModel *)model;
@end
