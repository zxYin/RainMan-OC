//
//  CalendarEventCell.h
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewModel.h"
@interface CourseTableCellStyle : NSObject
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *textColor;
@end


@interface CourseTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@end
