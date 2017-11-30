//
//  LKPermissionDenyAlertView.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKPermissionDenyAlertView.h"

@interface LKPermissionDenyAlertView()
@property (nonatomic, copy) void (^cancelBlock)();
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation LKPermissionDenyAlertView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.openButton.layer.cornerRadius = 3.0;
    self.openButton.layer.borderWidth = 1;
    self.openButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.cancelButton.layer.cornerRadius = 3.0;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (IBAction)openButtonDidClick:(id)sender {
    if (self.block) {
        self.block();
    }
    [[LKNoticeAlert currentNoticeAlert] dismiss];
}

- (IBAction)cancelButtonDidClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[LKNoticeAlert currentNoticeAlert] dismiss];
}


+ (instancetype)viewWithOpenBlock:(void (^)())openBlock cancelBlock:(void (^)())cancelBlock {
    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"LKPermissionDenyAlertView" owner:nil options:nil];
    LKPermissionDenyAlertView *view = [views firstObject];
    view.block = openBlock;
    view.cancelBlock = cancelBlock;
    return view;


}


@end
