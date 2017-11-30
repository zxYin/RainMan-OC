//
//  NoDataViewCell.h
//  XJTULink-iOS
//
//  Created by shchen on 15/10/30.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NoDataViewCellHeight 60
#define NoDataViewCellIdentifier @"NoDataViewCellIdentifier"
@interface NoDataViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
