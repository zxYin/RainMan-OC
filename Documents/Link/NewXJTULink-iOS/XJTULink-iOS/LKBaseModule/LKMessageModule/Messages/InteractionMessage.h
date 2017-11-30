//
//  InteractionMessage.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/30.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKMessage.h"
#import "LKUserModel.h"
#import "LKTextModel.h"

@interface InteractionMessage : LKMessage
@property (nonatomic, copy) NSString *referName;
@property (nonatomic, copy) NSString *referContent;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *tintColor;
@property (nonatomic, assign) BOOL allowReply;
@property (nonatomic, copy) LKUserModel *user;
@end
