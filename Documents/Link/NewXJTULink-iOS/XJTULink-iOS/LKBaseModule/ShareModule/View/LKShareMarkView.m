//
//  LKShareMarkView.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKShareMarkView.h"
#import "ViewsConfig.h"
@interface LKShareMarkView()
//@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@end

@implementation LKShareMarkView

+ (instancetype)shareMarkView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LKShareMarkView" owner:nil options:nil];
    LKShareMarkView *markView = [nibView objectAtIndex:0];
    markView.frame = CGRectMake(0,0,MainScreenSize.width, 30);
    return markView;
}

- (UIImage *)markImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
