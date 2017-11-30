//
//  LKTranscoder.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"
#import "NSString+Base64.h"

@interface NSString(LKTranscoder)
- (NSString *)md5String;
@end

@interface NSData(LKTranscoder)
- (NSString *)md5String;
@end
