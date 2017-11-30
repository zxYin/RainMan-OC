//
//  LKMessageListViewModel.m
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/26.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessageListViewModel.h"
#import "LKMessageListAPIManager.h"
#import "LKMessageCountAPIManager.h"
#import "LKMessageManager.h"
#import "LKMessageReplyAPIManager.h"

NSString * const kNetworkingRACTypeReply = @"kNetworkingRACTypeReply";
NSString * const kNetworkingRACTypeMessageList = @"kNetworkingRACTypeMessageList";

@interface LKMessageListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSArray<LKMessage *> *messageList;
@property (nonatomic, strong) YLNetworkingRACTable *networkingRACs;

@property (nonatomic, strong) LKMessageReplyAPIManager *replyAPIManager;
@property (nonatomic, strong) LKMessageListAPIManager *messageListAPIManager;
@property (nonatomic, copy) NSString *community;
@property (nonatomic, copy) NSString *option;
@end

@implementation LKMessageListViewModel
- (instancetype)initWithCommunity:(NSString *)community option:(NSString *)option {
    self = [super init];
    if (self) {
        self.community = community;
        self.option = option;
        [self setupRAC];
    }
    return self;
}

- (instancetype)init {
    return [self initWithCommunity:nil option:nil];
}

- (void)setupRAC {
    @weakify(self);
    [[self.networkingRACs[kNetworkingRACTypeMessageList] executionSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *messageList = [x boolValue]?[NSMutableArray array]:[NSMutableArray arrayWithArray:self.messageList];
        
        NSArray *newMessageList = [self.messageListAPIManager fetchDataFromModel:LKMessage.class];
        [messageList addObjectsFromArray:newMessageList];
        self.messageList = [messageList copy];
    }];
}

- (BOOL)hasNextPage {
    return self.messageListAPIManager.hasNextPage;
}

- (YLNetworkingRACTable *)networkingRACs {
    if (_networkingRACs == nil) {
        _networkingRACs = [YLNetworkingRACTable strongToWeakObjectsMapTable];
        _networkingRACs[kNetworkingRACTypeReply] = self.replyAPIManager;
        _networkingRACs[kNetworkingRACTypeMessageList] = self.messageListAPIManager;
    }
    return _networkingRACs;
}


- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (manager == self.messageListAPIManager) {
        params[LKMessageListAPIManagerParamsKeyCommunityId] = self.community;
        params[LKMessageListAPIManagerParamsKeyOptionId] = self.option;
    } else if(manager == self.replyAPIManager) {
        params[LKMessageReplyAPIManagerParamsKeyMessageId] = self.replyMessageId;
        params[LKMessageReplyAPIManagerParamsKeyContent] = self.replyContent;
    }
    return params;
}

#pragma mark - getter

- (LKMessageListAPIManager *)messageListAPIManager {
    if (_messageListAPIManager == nil) {
        _messageListAPIManager = [[LKMessageListAPIManager alloc] initWithPageSize:20];
        _messageListAPIManager.dataSource = self;
    }
    return _messageListAPIManager;
}

- (LKMessageReplyAPIManager *)replyAPIManager {
    if (_replyAPIManager == nil) {
        _replyAPIManager = [[LKMessageReplyAPIManager alloc] init];
        _replyAPIManager.dataSource = self;
    }
    return _replyAPIManager;
}
@end
