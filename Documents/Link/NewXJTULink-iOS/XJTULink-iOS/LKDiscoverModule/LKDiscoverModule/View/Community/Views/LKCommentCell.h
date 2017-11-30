//
//  ConfessionCommentCell.h
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCommentViewModel.h"
typedef void (^CommentActionBlock)(LKCommentViewModel *viewModel);

@interface LKCommentCell : UITableViewCell
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) LKCommentViewModel *viewModel;
@property (nonatomic, copy) CommentActionBlock commentActionBlcok;
@end
