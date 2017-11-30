//
//  CourseCountdownView.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseCountdownView.h"
#import "CourseCountdownViewModel.h"
#import <ReactiveCocoa.h>
@interface CourseCountdownView()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmpSecondLabel;

@end
@implementation CourseCountdownView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    RAC(self.timeLabel, text) = RACObserve(self.viewModel, time);
    RAC(self.rightLabel, text) = RACObserve(self.viewModel, rightText);
    RAC(self.leftLabel, text) = RACObserve(self.viewModel, leftText);
    RAC(self.tmpSecondLabel, text) = RACObserve(self.viewModel, second);
    RAC(self, hidden) =
    [RACObserve(self.viewModel, hasNext) not];
}


- (CourseCountdownViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[CourseCountdownViewModel alloc] init];
    }
    return _viewModel;
}


+ (instancetype)courseCountdownView {
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"CourseCountdownView" owner:nil options:nil];
    return [nibViews firstObject];
}
@end
