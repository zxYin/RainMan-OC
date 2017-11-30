//
//  LibraryLoginViewController.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/27.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



- (instancetype)initWithCallback:(void (^)())block;
@end
