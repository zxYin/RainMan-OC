//
//  AcademyPickerCell.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/4.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat const AcademyPickerCelllHeight = 93;
@interface AcademyPickerCell : UITableViewCell
@property (nonatomic, copy) NSArray *academies;
@property (nonatomic, copy) NSString *selectedAcademy;
@end
