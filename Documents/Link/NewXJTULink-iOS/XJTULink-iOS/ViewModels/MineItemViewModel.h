//
//  MineItemViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit.UIImage;



@interface MineItemViewModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSURL *webURL;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign, getter=isEnable) BOOL enable;
@end
