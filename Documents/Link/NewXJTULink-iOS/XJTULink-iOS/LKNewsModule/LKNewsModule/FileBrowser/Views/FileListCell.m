//
//  FileListCell.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/20.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "FileListCell.h"
#import "ColorMacros.h"
@interface FileListCell()

@end
@implementation FileListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainButton.layer.cornerRadius = 5.0;
    _mainButton.clipsToBounds = YES;
    _progressView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadButton:(UIButton *)sender {
    [_delegate downloadButtonDidClick:self];
}


- (void)downloadStart {
    self.status = FileNetworkStatusDownloading;
    _progressView.hidden = NO;
    _progressView.progressTintColor = LKColorLightBlue;
    [_mainButton setTitle:@"下载中" forState:UIControlStateNormal];
}

- (void)downloadPause {
    self.status = FileNetworkStatusPause;
    [_mainButton setTitle:@"继续" forState:UIControlStateNormal];
    self.progressView.progressTintColor = [UIColor lightGrayColor];
}

- (void)downloadFinished {
    self.status = FileNetworkStatusFinished;
    _progressView.hidden = YES;
    [_mainButton setTitle:@"查看" forState:UIControlStateNormal];
}
@end
