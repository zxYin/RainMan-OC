//
//  CalendarEventCell.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CourseTableCell.h"
#import <ReactiveCocoa.h>
@implementation CourseTableCellStyle

@end


@implementation CourseTableCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 1;
//    self.layer.borderColor = [[UIColor colorWithRed:79/255.0
//                                              green:189/255.0
//                                               blue:234/255.0
//                                              alpha:0.8] CGColor];
}





@end
