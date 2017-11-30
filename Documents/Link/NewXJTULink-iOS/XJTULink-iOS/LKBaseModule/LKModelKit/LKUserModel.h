//
//  LKUserModel.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTextModel.h"
#import <Mantle/Mantle.h>
// 这个是供查看其他用户信息时使用
@interface LKUserModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) LKTextModel *tag;
@end
