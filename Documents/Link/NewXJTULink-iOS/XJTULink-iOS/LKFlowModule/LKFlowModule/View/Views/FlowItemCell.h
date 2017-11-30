//
//  FlowItemCell.h
//  LKFlowModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const kFlowItemCellIdentifier;
@interface FlowItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end
