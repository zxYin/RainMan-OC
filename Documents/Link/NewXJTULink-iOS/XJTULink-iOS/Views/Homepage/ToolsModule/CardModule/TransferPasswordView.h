//
//  TransferPasswordView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/25.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TransferPasswordViewHeight 240


@interface TransferPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) void (^successAction)(NSString *password);
@property (strong,nonatomic) void (^closeAction)();
@property (strong,nonatomic) void (^forgetAction)();

- (void)close;
- (void)setInputLength:(NSInteger)length;

+ (TransferPasswordView *)transferPasswordViewWithSuccessAction:(void(^)(NSString *password))success CloseAction:(void(^)())close forgetAction:(void(^)())forget;
@end
