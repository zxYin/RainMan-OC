//
//  YPMenuCell.h
//  MenuTest
//
//  Created by Yunpeng on 16/4/23.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YPMenuCellHeight 40
#define YPMenuCellIdentifier @"YPMenuCellIdentifier"
@interface YPMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
