//
//  TranscriptsItemViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranscriptsItemModel.h"
@interface TranscriptsItemViewModel : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *score;
@property (nonatomic, assign, readonly, getter=isPass) BOOL pass;
- (instancetype)initWithModel:(TranscriptsItemModel *)model;
@end
