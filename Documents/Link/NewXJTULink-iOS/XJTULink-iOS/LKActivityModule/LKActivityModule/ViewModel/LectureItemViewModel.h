//
//  LectureItemViewModel.h
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LectureModel.h"
@interface LectureItemViewModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSURL *url;

- (instancetype)initWithModel:(LectureModel *)model;
@end
