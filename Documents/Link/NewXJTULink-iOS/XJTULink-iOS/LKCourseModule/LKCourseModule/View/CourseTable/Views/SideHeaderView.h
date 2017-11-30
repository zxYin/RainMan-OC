//
//  SideHeaderView.h
//  Calendar
//
//  Created by Yunpeng on 16/3/29.
//  Copyright © 2016年 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const SideHeaderViewIdentifier;
@interface SideHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
