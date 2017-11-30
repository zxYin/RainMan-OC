//
//  LKUpdateViewController.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKUpdateViewController.h"
#import "Macros.h"

@interface LKUpdateViewController ()

@end

@implementation LKUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateButtonDidClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStorePath]];
}

@end
