//
//  ConfessionDetailWithAvatarCell.h
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/15.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPostViewModel.h"
#import "LKAvatarView.h"
typedef void (^ConfessionWithAvatarReferBlock)();
@interface LKPostDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *referStudentBtn;
@property (nonatomic,strong) LKPostViewModel *viewModel;
@property (nonatomic, copy) ConfessionWithAvatarReferBlock referBlock;
@end
