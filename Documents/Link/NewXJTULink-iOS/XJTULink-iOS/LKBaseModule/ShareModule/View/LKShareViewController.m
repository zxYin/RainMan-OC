//
//  LKShareViewController.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKShareViewController.h"
#import "ViewsConfig.h"
@interface LKShareViewController ()
@property (nonatomic, strong) UIImage *sharedImage;
@property (weak, nonatomic) IBOutlet UIImageView *sharedImageView;

@end

@implementation LKShareViewController
- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.sharedImage = image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片分享";
    self.sharedImageView.image = self.sharedImage;
    
}


@end
