//
//  ConfessionEditViewController.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPostModel.h"

typedef void (^ConfessionDidSubmitBlock)(LKPostModel *model);
@interface LKPostEditViewController : UIViewController
@property (nonatomic, copy) ConfessionDidSubmitBlock didSubmitBlock;
@end
