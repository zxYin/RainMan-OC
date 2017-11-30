//
//  LKNoticeManager.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/1/3.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef NS_ENUM(NSInteger, LKNoticeType) {
//    LKNoticeTypeText,
//    LKNoticeTypeImage,
//};
// Protocol
@protocol LKNotice <NSObject>
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pageTitle;
@end


extern NSString * const LKNoticeTypeText;
extern NSString * const LKNoticeTypeImage;
extern NSString * const LKNoticeTypeConfession;

extern NSString * const LKGlobalNotice;

@interface LKNoticeManager : NSObject
@property (nonatomic, copy) NSDictionary *notices;

+ (instancetype)sharedInstance;
- (void)setupTest;
@end
