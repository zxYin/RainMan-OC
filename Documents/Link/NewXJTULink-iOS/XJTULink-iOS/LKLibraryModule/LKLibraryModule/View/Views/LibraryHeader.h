//
//  LibraryHeader.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/5/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LibraryHeaderHeight 165
@interface LibraryHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fineLabel;


+ (LibraryHeader *)libraryHeader;
@end
