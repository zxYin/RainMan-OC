//
//  ConfessionMainContentCell.h
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/3/29.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPostViewModel.h"
typedef void (^ConfessionReferBlock)();

@interface LKAnonymousPostDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *referStudentBtn;


@property (nonatomic,strong) LKPostViewModel *viewModel;
@property (nonatomic, copy) ConfessionReferBlock referBlock;

+ (instancetype)mainContentView;
@end
