//
//  MineItemCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MineItemCellHeight 45
@interface MineItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
