//
//  TransferPasswordView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/25.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "TransferPasswordView.h"
//#import "Setting.h"
//#import "AppConst.h"
#import "ViewsConfig.h"
static const NSInteger BaseTagNumber = 100;

@interface TransferPasswordView()

@end

@implementation TransferPasswordView


- (void)awakeFromNib {
    [super awakeFromNib];
    [_passwordTextField becomeFirstResponder];
    [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)drawRect:(CGRect)rect {
//    [UIView drawLineFrom:CGPointMake(0, 40) to:CGPointMake(ScreenSize.width, 40) withColor:LCOLOR_LIGHT_GRAY withWidth:0.5];
}
- (void)close {
    [self closeAction:nil];
}
- (IBAction)closeAction:(UIButton *)sender {
    [_passwordTextField resignFirstResponder];
    self.closeAction();
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, MainScreenSize.height, MainScreenSize.width, 200);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)setInputLength:(NSInteger)length {
    for (NSInteger index = 0; index<6; index++) {
        UIView *view = [self viewWithTag:BaseTagNumber+index];
        if (index<length) {
            view.hidden = NO;
        } else {
            view.hidden = YES;
        }
    }
}

- (void) textFieldDidChange:(UITextField *) textField {
    NSString *password = [textField text];
    if (password.length >= 6) {
        [self setInputLength:6];
        [_passwordTextField resignFirstResponder];
        self.successAction(password);
    } else {
        [self setInputLength:[textField text].length];
    }
}

+ (TransferPasswordView *)transferPasswordViewWithSuccessAction:(void(^)(NSString *))success CloseAction:(void(^)())close forgetAction:(void(^)())forget {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TransferPasswordView" owner:nil options:nil];
    TransferPasswordView *view = nibs.lastObject;
    view.closeAction = close;
    view.forgetAction = forget;
    view.successAction = success;
    return nibs.lastObject;
}

@end
