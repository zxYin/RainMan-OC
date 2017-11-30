//
//  ShareModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit.UIImage;

typedef NS_ENUM(NSInteger, LKShareType) {
    kLKShareTypeURL = 0,
    kLKShareTypeImage,
};

#define ShareModelDefaultImage [UIImage imageNamed:@"logo"];
@interface LKShareModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) LKShareType type; //预留


- (instancetype)initWithURL:(NSString *)url title:(NSString *)title summary:(NSString *)summary image:(UIImage *)image;

+ (instancetype)modelWithURL:(NSString *)url title:(NSString *)title summary:(NSString *)summary image:(UIImage *)image;
@end
