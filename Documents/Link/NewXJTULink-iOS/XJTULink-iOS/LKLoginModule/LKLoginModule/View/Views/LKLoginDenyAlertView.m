//
//  LKPermissionDenyAlertView.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKLoginDenyAlertView.h"

@interface LKLoginDenyAlertView()
@property (nonatomic, copy) void (^cancelBlock)();
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end

@implementation LKLoginDenyAlertView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.openButton.layer.cornerRadius = 3.0;
    self.openButton.layer.borderWidth = 1;
    self.openButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
}

- (IBAction)openButtonDidClick:(id)sender {
    if (self.block) {
        self.block();
    }
    [[LKNoticeAlert currentNoticeAlert] dismiss];
}


+ (instancetype)viewWithBlock:(void (^)())block {
    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"LKLoginDenyAlertView" owner:nil options:nil];
    LKLoginDenyAlertView *view = [views firstObject];
    view.block = block;
    return view;
}



@end
