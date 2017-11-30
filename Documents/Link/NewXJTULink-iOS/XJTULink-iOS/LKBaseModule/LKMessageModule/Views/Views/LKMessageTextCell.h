//
//  LKMessageTextCell.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKMessage.h"
@interface LKMessageTextCell : UITableViewCell<LKMessageCell>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end
