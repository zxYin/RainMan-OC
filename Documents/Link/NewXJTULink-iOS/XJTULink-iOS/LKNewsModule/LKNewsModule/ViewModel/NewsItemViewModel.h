//
//  NewsViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/17.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNetworking.h"
#import "NewsModel.h"
@interface NewsItemViewModel : NSObject
@property (nonatomic, copy, readonly) NewsModel *model;

@property (nonatomic, copy, readonly) NSString *pageTitle;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSURL *originURL;
@property (nonatomic, copy, readonly) NSString *newsId;
@property (nonatomic, assign, readonly) BOOL hasAccessory;

@property (nonatomic, assign) BOOL boxHidden;
- (instancetype)initWithModel:(NewsModel *)model;
@end
