//
//  TeachingAdviceCell.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "TeachingAdviceCell.h"
#import "ViewsConfig.h"
@implementation TeachingAdviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BRPlaceholderTextView *)textView {
    if (_textView == nil) {
        _textView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectZero];
    }
    return _textView;
}

@end
