//
//  LKSecurity.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 注意此处的private和public证书并非成对，故此处的加解密均不可逆
 */
@interface LKSecurity : NSObject

+ (instancetype)sharedInstance;

/**
 使用public证书对字符串进行加密

 @param string
 @return string
 */
- (NSString *)rsaEncryptString:(NSString*)string;


/**
 使用private证书对字符串进行解密
 
 @param string
 @return
 */
- (NSString *)rsaDecryptString:(NSString*)string;





/**
 验证签名 Sha1 + RSA
 */
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;


/**
 验证签名 md5 + RSA
 */
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString;



// 用private证书对字符串进行签名
- (NSString *)signString:(NSString *)string;


- (NSString *)signMD5String:(NSString *)string;





//+ (NSString *)aesEncryptString:(NSString *)message password:(NSString *)password;
//
//+ (NSString *)aesDecryptString:(NSString *)base64EncodedString password:(NSString *)password;

@end
