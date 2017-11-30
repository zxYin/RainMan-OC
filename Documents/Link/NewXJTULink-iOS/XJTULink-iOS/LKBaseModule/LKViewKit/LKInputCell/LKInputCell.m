//
//  LKInputCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/22.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKInputCell.h"
NSString * const LKInputCellIdentifier = @"LKInputCell";
@interface LKInputCell ()

@end

@implementation LKInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
//    self.
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
