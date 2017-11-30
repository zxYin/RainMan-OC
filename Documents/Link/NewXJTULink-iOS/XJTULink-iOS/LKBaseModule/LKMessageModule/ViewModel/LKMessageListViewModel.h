//
//  LKMessageListViewModel.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessage.h"
#import "LKNetworking.h"
extern NSString * const kNetworkingRACTypeReply;
extern NSString * const kNetworkingRACTypeMessageList;

@interface LKMessageListViewModel : NSObject<YLNetworkingRACProtocol>
@property (nonatomic, copy, readonly) NSArray<LKMessage *> *messageList;
@property (nonatomic, assign, readonly) BOOL hasNextPage;

@property (nonatomic, copy) NSString *replyMessageId;
@property (nonatomic, copy) NSString *replyContent;

@property (nonatomic, copy, readonly) NSString *community;
@property (nonatomic, copy, readonly) NSString *option;

- (instancetype)initWithCommunity:(NSString *)community option:(NSString *)option;
@end
