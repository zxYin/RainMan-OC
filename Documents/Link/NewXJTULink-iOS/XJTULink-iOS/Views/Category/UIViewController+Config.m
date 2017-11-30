//
//  UIViewController+Config.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UIViewController+Config.h"
#import "Foundation+LKTools.h"

@implementation UIViewController (Config)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject methodSwizzlingWithTarget:@selector(viewDidLoad)
                                      using:@selector(viewDidLoad_setupBackItem)
                                   forClass:[UIViewController class]];
    });
    
}

- (void)viewDidLoad_setupBackItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self viewDidLoad_setupBackItem];
}




@end
