//
//  TranscriptsManager.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/25.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranscriptsItemModel.h"
#import "LKNetworking.h"

@interface TranscriptsManager : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSArray<TranscriptsItemModel *> *> *transcripts;

+ (instancetype)sharedInstance;
@end
