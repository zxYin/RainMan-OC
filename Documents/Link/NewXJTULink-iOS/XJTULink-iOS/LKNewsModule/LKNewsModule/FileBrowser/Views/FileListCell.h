//
//  FileListCell.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/20.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessoryModel.h"
#define FileListCellHeight 80
#define FileListCellIdentifier @"FileListCell"

typedef NS_ENUM(NSInteger,FileNetworkStatus) {
    FileNetworkStatusDownloading = 0,
    FileNetworkStatusPause,
    FileNetworkStatusFinished,
};

@class FileListCell;
@protocol FileListCellDelegate<NSObject>
- (void)downloadButtonDidClick:(FileListCell *)cell;
@end

@interface FileListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak,nonatomic) id<FileListCellDelegate> delegate;
@property (strong,nonatomic) AccessoryModel *file;
@property (assign ,nonatomic) FileNetworkStatus status;

- (void)downloadStart;
- (void)downloadPause;
- (void)downloadFinished;
@end
