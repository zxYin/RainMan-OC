//
//  LKConfessionEntryCell.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LKCommunityEntryCellHeight (CGRectGetWidth([UIScreen mainScreen].bounds) * 9 / 21)
@interface LKCommunityEntryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *entryImageView;

@end
