//
//  PGGCryptoMD5.m
//  PGGCrypto
//
//  Created by 陈鹏 on 2017/10/24.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//  GitHub地址  https://github.com/penghero/PGGCrypto.git

#import "PGGCryptoMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PGGCryptoMD5

+ (NSString *)pggMD5:(NSString *)input {
    if (!input) {
        return nil;
    }
    const char* cStr = [input UTF8String];//先转为UTF_8编码的字符串
    //声明一个字符数组，可存放16个字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];//设置一个接受字符数组 /md5加密后是128bit, 16 字节 * 8位/字节 = 128 位
    CC_MD5(cStr,  (unsigned)strlen(cStr), result);
    
    static const char HexEncodeChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    char *resultData = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);
    
    for (uint index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
        resultData[index * 2] = HexEncodeChars[(result[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeChars[(result[index] % 0x10)];
    }
    resultData[CC_MD5_DIGEST_LENGTH * 2] = 0;
    
    NSString *resultString = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    free(resultData);
    
    return [resultString uppercaseString];
}

@end
