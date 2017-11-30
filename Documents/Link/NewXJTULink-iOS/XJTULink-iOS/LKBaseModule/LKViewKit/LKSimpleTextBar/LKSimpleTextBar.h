//
//  LKSimpleTextBar.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LKSimpleTextBarHeight 44
@interface LKSimpleTextBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *button;
+ (instancetype)simpleTextBarWithBlock:(void (^)())block;
@end
