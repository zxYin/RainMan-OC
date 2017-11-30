//
//  LKSecurity.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/11/30.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKSecurity.h"
#import "Foundation+LKTools.h"
#include <openssl/pkcs12.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <openssl/md5.h>

#define JSMIN(X, Y) (((X) < (Y)) ? (X) : (Y))

// 这里使用C函数是为了安全
RSA *LKRSAFromP12() {
    FILE *fp;
    EVP_PKEY *pkey;
    X509 *cert;
    STACK_OF(X509) *ca = NULL;
    PKCS12 *p12;
    
    OpenSSL_add_all_algorithms();
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    if (!(fp = fopen([keyPath UTF8String], "r"))) {
        return NULL;
    }
    p12 = d2i_PKCS12_fp(fp, NULL);
    fclose (fp);
    if (!p12) {
        return NULL;
    }
    
    if (!PKCS12_parse(p12, "xjtu@ssl.linkP12", &pkey, &cert, &ca)) {
        return NULL;
    }
    PKCS12_free(p12);
    
    if (pkey) {
        return pkey->pkey.rsa;
    } else {
        return NULL;
    }
}

RSA *LKRSAFromPEM() {
    RSA *rsa_publicKey = NULL;
    FILE *fp_publicKey;
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"pem"];
    if ((fp_publicKey = fopen([keyPath UTF8String], "r")) == NULL) {
        printf("Could not open %s\n", [keyPath UTF8String]);
        return NULL;
    }
    
    if ((rsa_publicKey = PEM_read_RSAPublicKey(fp_publicKey, NULL, NULL, NULL)) == NULL) {
        fclose(fp_publicKey);
        printf("Error loading RSA Public Key File.");
        return NULL;
    }
    fclose(fp_publicKey);
    return rsa_publicKey;
}


@interface LKSecurity() {
/*
 * 注意此处publicRSA和privateRSA并不是一对
 * publicRSA是用于向服务器请求时，对token的加密
 * privateRSA是用于登录时，解密从服务器传回的token
 *
 */
    RSA *_privateRSA;
    RSA *_publicRSA;
}

@end

@implementation LKSecurity
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKSecurity *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKSecurity alloc] init];
        [instance setupRSA];
    });
    return instance;
}

- (void)setupRSA {
    if (NULL != _privateRSA) {
        RSA_free(_privateRSA);
        _privateRSA = NULL;
    }
    if (NULL != _publicRSA) {
        RSA_free(_publicRSA);
        _publicRSA = NULL;
    }
    
    _privateRSA = LKRSAFromP12();
    _publicRSA = LKRSAFromPEM();
    
    if (_privateRSA !=NULL && _publicRSA!=NULL) {
        NSLog(@"[LKSecurity]证书加载成功");
    } else {
        NSLog(@"[LKSecurity]证书加载失败");
    }
}

#pragma mark - Public API
-(NSString*) rsaEncryptString:(NSString*)string {
    if(string == nil) {
        return nil;
    }
    
    const char *plain_text = [string UTF8String];
    
    int rsa_public_len = RSA_size(_publicRSA);
    
    int chunk_length = rsa_public_len - 11;
    int plain_char_len = (int)strlen(plain_text);
    int num_of_chunks = (int)(strlen(plain_text) / chunk_length) + 1;
    
    int total_cipher_length = 0;
    int encrypted_size = (num_of_chunks * rsa_public_len);
    unsigned char *cipher_data = malloc(encrypted_size + 1);
    
    for (int i = 0; i < plain_char_len; i += chunk_length) {
        int remaining_char_count = plain_char_len - i;
        int len = JSMIN(remaining_char_count, chunk_length);
        unsigned char *plain_chunk = malloc(len + 1);\
        memcpy(&plain_chunk[0], &plain_text[i], len);
        
        unsigned char *result_chunk = malloc(rsa_public_len + 1);
        int result_length = RSA_public_encrypt(len, plain_chunk, result_chunk, _publicRSA, RSA_PKCS1_PADDING);
        free(plain_chunk);
        
        if (result_length == -1) {
            ERR_load_CRYPTO_strings();
        }
        
        memcpy(&cipher_data[total_cipher_length], &result_chunk[0], result_length);
        
        total_cipher_length += result_length;
        
        free(result_chunk);
    }
    NSData *data = [[NSData alloc]initWithBytes:cipher_data length:encrypted_size];
    return  [data base64EncodedString];
}

- (NSString*) rsaDecryptString:(NSString*)string {
    if(string == nil) {
        return nil;
    }
    
    NSData *data = [string base64DecodedData];
    if (data && [data length]) {
        int flen = (int)[data length];
        unsigned char from[flen];
        bzero(from, sizeof(from));
        memcpy(from, [data bytes], [data length]);
        unsigned char to[128];
        bzero(to, sizeof(to));
        RSA_private_decrypt(flen, from, to, _privateRSA, RSA_PKCS1_PADDING);
        return [NSString stringWithCString:(const char *)to encoding:NSUTF8StringEncoding];
    }
    return nil;
}


#pragma mark RSA sha1验证签名
//signString为base64字符串
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString {
    if (!_publicRSA) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    

    unsigned char sha1[20];
    SHA1((unsigned char *)message, messageLength, sha1);
    int verify_ok = RSA_verify(NID_sha1
                               , sha1, 20
                               , sig, sig_len
                               , _publicRSA);
    
    if (1 == verify_ok){
        return YES;
    }
    return NO;
    
    
}
#pragma mark RSA MD5 验证签名
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString {
    if (!_publicRSA) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    int verify_ok = RSA_verify(NID_md5
                               , digest, MD5_DIGEST_LENGTH
                               , sig, sig_len
                               , _publicRSA);
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
    
}

- (NSString *)signString:(NSString *)string {
    if (!_privateRSA) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char sha1[20];
    SHA1((unsigned char *)message, messageLength, sha1);
    
    int rsa_sign_valid = RSA_sign(NID_sha1
                                  , sha1, 20
                                  , sig, &sig_len
                                  , _privateRSA);
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
}

- (NSString *)signMD5String:(NSString *)string {
    if (!_privateRSA) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    //int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    
    int rsa_sign_valid = RSA_sign(NID_md5
                                  , digest, MD5_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , _privateRSA);
    
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
}



//
//- (NSData *) AES256EncryptedDataUsingKey: (id) key error: (NSError **) error
//{
//    CCCryptorStatus status = kCCSuccess;
//    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmAES128
//                                                    key: key
//                                                options: kCCOptionPKCS7Padding
//                                                  error: &status];
//    
//    if ( result != nil )
//        return ( result );
//    
//    if ( error != NULL )
//        *error = [NSError errorWithCCCryptorStatus: status];
//    
//    return ( nil );
//}
//
//- (NSData *) decryptedAES256DataUsingKey: (id) key error: (NSError **) error
//{
//    CCCryptorStatus status = kCCSuccess;
//    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmAES128
//                                                    key: key
//                                                options: kCCOptionPKCS7Padding
//                                                  error: &status];
//    
//    if ( result != nil )
//        return ( result );
//    
//    if ( error != NULL )
//        *error = [NSError errorWithCCCryptorStatus: status];
//    
//    return ( nil );
//}















@end
