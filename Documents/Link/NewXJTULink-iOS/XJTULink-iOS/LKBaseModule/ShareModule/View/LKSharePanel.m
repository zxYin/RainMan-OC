//
//  LKSharePanel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSharePanel.h"
#import "LKShareManager.h"
@interface LKSharePanel ()

@end

@implementation LKSharePanel

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    if (self) {
        [self setupLine];
    }
    return self;
}

- (instancetype)initWithShareModel:(LKShareModel *)model {
    self = [super initWithTitle:model.title];
    if (self) {
        self.shareModel = model;
        [self setupLine];
    }
    return self;
}


- (void)setupLine {
    YLAlertPanelLine *line = [[YLAlertPanelLine alloc] init];
    LKShareManager *manager = [LKShareManager sharedInstance];
    if([manager isInstall:kSharePlatformTypeWXMoments]) {
        [line addButtonWithTitle:@"朋友圈" image:[UIImage imageNamed:@"share_icon_wxmoments"] handler:^(YLAlertPanelButton *button) {
            NSLog(@"分享至朋友圈");
            [manager shareWithModel:self.shareModel platform:kSharePlatformTypeWXMoments];
        }];
    }
    
    if([manager isInstall:kSharePlatformTypeWechat]) {
        [line addButtonWithTitle:@"微信" image:[UIImage imageNamed:@"share_icon_wechat"] handler:^(YLAlertPanelButton *button) {
            NSLog(@"分享至微信");
            [manager shareWithModel:self.shareModel platform:kSharePlatformTypeWechat];
        }];
    }
    
    if([manager isInstall:kSharePlatformTypeSina]) {
        [line addButtonWithTitle:@"微博" image:[UIImage imageNamed:@"share_icon_sina"] handler:^(YLAlertPanelButton *button) {
            NSLog(@"分享至微博");
            [manager shareWithModel:self.shareModel platform:kSharePlatformTypeSina];
        }];
        
    }
   
    if([manager isInstall:kSharePlatformTypeQQ]) {
        [line addButtonWithTitle:@"QQ" image:[UIImage imageNamed:@"share_icon_qq"] handler:^(YLAlertPanelButton *button) {
            NSLog(@"分享至QQ");
            [manager shareWithModel:self.shareModel platform:kSharePlatformTypeQQ];
        }];
    }
    
    if([manager isInstall:kSharePlatformTypeQzone]) {
        [line addButtonWithTitle:@"QQ空间" image:[UIImage imageNamed:@"share_icon_qzone"] handler:^(YLAlertPanelButton *button) {
            NSLog(@"分享至QQ空间");
            [manager shareWithModel:self.shareModel platform:kSharePlatformTypeQzone];
        }];
    }
    
    if(self.shareModel && self.shareModel.type == kLKShareTypeURL) {
        [line addButtonWithTitle:@"Safari" image:[UIImage imageNamed:@"share_icon_safari"] handler:^(YLAlertPanelButton *button) {
            NSURL *url = [NSURL URLWithString:self.shareModel.url];
            [[UIApplication sharedApplication] openURL:url];
        }];
    }

    if (line.countOfButtons != 0) {
        [self addLine:line];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

@end
