//
//  LKUpdateView.m
//  LKNoticeAlert
//
//  Created by Yunpeng on 2016/12/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKUpdateAlertView.h"
#import "LKNoticeAlert.h"
@interface LKUpdateAlertView()
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@end

@implementation LKUpdateAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.updateButton.layer.cornerRadius = 3.0;
    self.updateButton.layer.borderWidth = 1;
    self.updateButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.skipButton.layer.cornerRadius = 3.0;
    self.skipButton.layer.borderWidth = 1;
    self.skipButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    [self.updateButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonDidClick:(UIButton *)sender {
    if (self.updateBlock) {
        self.updateBlock();
    }
    [[LKNoticeAlert currentNoticeAlert] dismiss];
    
}
- (IBAction)skipButtonDidClick:(id)sender {
    if (self.skipBlock) {
        self.skipBlock();
    }
    [[LKNoticeAlert currentNoticeAlert] dismiss];
}

+ (instancetype)viewWithUpdateBlock:(void (^)())block skipBlock:(void (^)())skipBlock {
    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"LKUpdateAlertView" owner:nil options:nil];
    LKUpdateAlertView *view = [views firstObject];
    view.updateBlock = block;
    view.skipBlock = skipBlock;
    return view;
}

@end
