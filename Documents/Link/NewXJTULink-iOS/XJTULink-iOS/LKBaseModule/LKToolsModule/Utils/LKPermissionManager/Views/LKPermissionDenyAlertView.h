//
//  LKPermissionDenyAlertView.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNoticeAlert.h"

#import "LKNoticeAlertContentView.h"
@interface LKPermissionDenyAlertView : LKNoticeAlertContentView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


+ (instancetype)viewWithOpenBlock:(void (^)())openBlock cancelBlock:(void (^)())cancelBlock;
@end
