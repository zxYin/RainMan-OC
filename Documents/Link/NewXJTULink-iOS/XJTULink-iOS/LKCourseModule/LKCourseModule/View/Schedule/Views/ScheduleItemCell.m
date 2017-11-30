//
//  ScheduleItemCell.m
//  LKCourseModule
//
//  Created by 李尧 on 2017/4/11.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "ScheduleItemCell.h"
#import "ColorMacros.h"
#import "ViewsConfig.h"
#import "Foundation+LKTools.h"
@interface ScheduleItemCell()

@end

@implementation ScheduleItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self)
    [RACObserve(self, viewModel) subscribeNext:^(ScheduleItemViewModel *viewModel) {
        @strongify(self)
        RAC(self.nameLabel, text) = [[RACObserve(viewModel, name) takeUntil:self.rac_prepareForReuseSignal] map:^id(id value) {
            if([NSString notBlank:self.title]) {
                return self.title;
            }
            return value;
        }];
        RAC(self.timeLabel, text) = [RACObserve(viewModel, time) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.localeLabel, text) = [RACObserve(viewModel, locale) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.leftDayLabel, text) = [[RACObserve(viewModel, leftDay) takeUntil:self.rac_prepareForReuseSignal] map:^id(id value) {
            return [NSString stringWithFormat:@"%@", value];
        }];
        
        RAC(self.dayInfoView, hidden) = [RACObserve(viewModel, isEnd) takeUntil:self.rac_prepareForReuseSignal];
        RAC(self.endLabel, hidden) = [[RACObserve(viewModel, isEnd) takeUntil:self.rac_prepareForReuseSignal] map:^id(id value) {
            return @(![value boolValue]);
        }];
        [self updateViewColor];
    }];
}

- (void)updateViewColor {
    if (self.viewModel.isEnd) {
        self.contentView.alpha = 0.5;
    } else {
        self.contentView.alpha = 1;
        if (self.viewModel.leftDay < 10 && self.viewModel.leftDay >= 0) {
            self.leftDayLabel.textColor = LKColorRed;
            self.dayLabel.textColor = LKColorRed;
        } else {
            self.leftDayLabel.textColor = LKColorLightBlue;
            self.dayLabel.textColor = LKColorLightBlue;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - YLTableViewCellProtocol
- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

+ (CGFloat)height {
    return ScheduleItemCellHeight;
}

@end
