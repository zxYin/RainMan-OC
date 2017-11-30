//
//  LKTranscoder.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKTranscoder.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(LKTranscoder)
- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end


@implementation NSData(LKTranscoder)
- (NSString *)md5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
