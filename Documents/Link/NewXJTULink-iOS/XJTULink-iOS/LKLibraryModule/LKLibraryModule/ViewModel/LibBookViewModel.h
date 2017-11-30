//
//  LibBookViewModel.h
//  LKLibraryModule
//
//  Created by Yunpeng on 2016/11/15.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibBookModel.h"
@interface LibBookViewModel : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSString *countdown;

- (instancetype)initWithModel:(LibBookModel *)model;
@end
