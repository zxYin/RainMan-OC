//
//  MineItemViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MineItemViewModel.h"

@implementation MineItemViewModel
- (UIImage *)image {
    if (_image == nil) {
        _image = [UIImage imageNamed:@"me_default_normal"];
    }
    return _image;
}
@end
