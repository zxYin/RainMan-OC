//
//  LKAvatarView.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKAvatarView.h"
@implementation LKAvatarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;
    self.avatarImageView.clipsToBounds = YES;
    
}

- (BOOL)usingSelfSizing {
    return YES;
}

@end
