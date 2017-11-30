//
//  CourseAdPageView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseAdPageView.h"
#import "ViewsConfig.h"
#import "ColorMacros.h"

NSString *const CourseAdPageViewIdentifier = @"CourseAdPageView";
@interface CourseAdPageView()
@property (weak, nonatomic) IBOutlet UILabel *tag1Label;
@property (weak, nonatomic) IBOutlet UILabel *tag2Label;
@property (weak, nonatomic) IBOutlet UILabel *tag3Label;
@end
@implementation CourseAdPageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.courseTimeLabel.layer.backgroundColor = LKColorLightBlue.CGColor;
    self.courseTimeLabel.layer.cornerRadius = 5.0;
    self.courseTimeLabel.textColor = [UIColor whiteColor];
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self);
        self.courseNameLabel.text = self.viewModel.name;
        self.courseTimeLabel.text = [self.viewModel.time stringByAppendingString:@"  "];
        self.courseRawTimeLabel.text = self.viewModel.rawTime;
        self.courseLocaleLabel.text = self.viewModel.locale;
        [self.courseTimeLabel sizeToFit];
    }];
}
@end
