//
//  TranscriptsViewModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranscriptsItemViewModel.h"
#import "LKCourseModule.h"
@interface TranscriptsViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy) NSArray *semesters;
@property (nonatomic, copy) NSDictionary<NSString *,NSArray<TranscriptsViewModel *> *> *transcriptsItemViewModels;

@end
