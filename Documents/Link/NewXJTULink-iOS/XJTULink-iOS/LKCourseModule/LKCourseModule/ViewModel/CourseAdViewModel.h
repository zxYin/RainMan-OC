//
//  CourseAdViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseViewModel.h"
#import "LKNetworking.h"
@interface CourseAdViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, assign, readonly) NSInteger visiableIndex;
@property (nonatomic, copy, readonly) NSArray<CourseViewModel *> *courseViewModels;
@end
