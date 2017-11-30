//
//  AcademyManager.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const kAcademyNotSet;
@interface AcademyManager : NSObject
@property (nonatomic, copy) NSArray<NSString *> *academyList;
+ (instancetype)sharedInstance;
- (void)setNeedsUpdate;
@end
