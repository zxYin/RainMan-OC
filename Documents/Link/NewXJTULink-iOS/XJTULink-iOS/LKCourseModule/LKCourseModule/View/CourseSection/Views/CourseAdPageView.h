//
//  CourseAdPageView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewModel.h"
extern NSString *const CourseAdPageViewIdentifier;
@interface CourseAdPageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLocaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseRawTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;

@property (nonatomic, strong) CourseViewModel *viewModel;
@end
