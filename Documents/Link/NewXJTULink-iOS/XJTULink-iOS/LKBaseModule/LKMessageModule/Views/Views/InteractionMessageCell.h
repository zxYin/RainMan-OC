//
//  InteractionMessageCell.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/30.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAvatarView.h"
#import "LKMessage.h"

@interface InteractionMessageCell : UITableViewCell<LKMessageCell>
@property (nonatomic, copy) ReplyButtonDidClickBlock replyButtonDidClickBlock;
@property (weak, nonatomic) IBOutlet LKAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *referContentLabel;

@end
