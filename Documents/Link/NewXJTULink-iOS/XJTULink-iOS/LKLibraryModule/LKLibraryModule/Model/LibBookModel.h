//
//  LibBook.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/5/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface LibBookModel : MTLModel<MTLJSONSerializing>
@property (copy,nonatomic,readonly) NSString *uuid;
@property (copy,nonatomic) NSString *date;
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *callNumber;
@property (assign,nonatomic) BOOL isOrdered;
- (NSInteger) countdown;
@end
