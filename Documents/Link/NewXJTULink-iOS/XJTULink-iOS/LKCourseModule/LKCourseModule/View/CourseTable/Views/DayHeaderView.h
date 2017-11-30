//
//  HeaderView.h
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const DayHeaderViewIdentifier;
@interface DayHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;

@property (assign, nonatomic, getter=isSelected) BOOL selected;
@end
