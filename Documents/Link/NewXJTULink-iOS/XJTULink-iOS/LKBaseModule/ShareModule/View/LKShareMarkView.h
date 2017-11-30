//
//  LKShareMarkView.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKShareMarkView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

+ (instancetype)shareMarkView;
- (UIImage *)markImage;
@end
