//
//  PGGCryptoDES.m
//  PGGCrypto
//
//  Created by 陈鹏 on 2017/10/24.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//  GitHub地址  https://github.com/penghero/PGGCrypto.git

#import "PGGCryptoDES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#define CRYPTO_KEY @"DES-BOCD-P&CDSJA"
#define CRYPTO_IV  @"DES-NNSMDA"

@implementation PGGCryptoDES

// 加密
+ (NSString *)Encrypt:(NSString *)input {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCEncrypt key:CRYPTO_KEY iv:CRYPTO_IV];
}

+ (NSString *)Encrypt:(NSString *)input withKey:(NSString *)key {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCEncrypt key:key iv:CRYPTO_IV];
}

+ (NSString *)Encrypt:(NSString *)input withKey:(NSString *)key iv:(NSString *)iv {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCEncrypt key:key iv:iv];
}

// 解密
+ (NSString *)Decrypt:(NSString *)input {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCDecrypt key:CRYPTO_KEY iv:CRYPTO_IV];
}

+ (NSString *)Decrypt:(NSString *)input withKey:(NSString *)key {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCDecrypt key:key iv:CRYPTO_IV];
}

+ (NSString *)Decrypt:(NSString *)input withKey:(NSString *)key v:(NSString *)iv {
    return [PGGCryptoDES TripleDES:input encryptOrDecrypt:kCCDecrypt key:key iv:iv];
}



#pragma mark - private
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key iv:(NSString*)iv {
    const void *vplainText;
    size_t plainTextBufferSize;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    CCCrypt(encryptOrDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySizeDES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    if (bufferPtr) {
        //add 释放
        free(bufferPtr);
    }
    return result;
}

@end
