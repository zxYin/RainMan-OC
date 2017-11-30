//
//  ConfessionItemCell.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/25.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPostViewModel.h"

@interface LKAnonymousPostCell : UITableViewCell
@property (nonatomic, strong) LKPostViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;

@property (nonatomic, assign) BOOL blurry;
@end
