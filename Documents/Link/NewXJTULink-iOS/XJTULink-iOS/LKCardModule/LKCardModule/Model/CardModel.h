//
//  CardModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>
@interface CardModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *transitionBalance;

@end
