//
//  LKMessage.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKNoticeAlertContentView.h"
#import <Mantle/Mantle.h>
#import "LKTextModel.h"

@class LKMessage;

@protocol LKMessage <NSObject>
@required
+ (NSString *)type;
+ (NSString *)cellName;
@end

typedef void (^ReplyButtonDidClickBlock)(LKMessage *message, NSString *placeholder);

@protocol LKMessageCell <NSObject>
@required
- (void)configWithModel:(LKMessage *)model;

@optional
- (void)setReplyButtonDidClickBlock:(ReplyButtonDidClickBlock)block;
@end


@interface LKMessage : MTLModel<MTLJSONSerializing,LKMessage>
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, copy) NSURL *command;
@property (nonatomic, copy) LKTextModel *tag;

@end
