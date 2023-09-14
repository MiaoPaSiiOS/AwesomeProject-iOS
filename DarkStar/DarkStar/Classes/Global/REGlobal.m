//
//  REGlobal.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/17.
//

#import "REGlobal.h"
#import "PGGCryptoRSA.h"

@implementation REGlobal

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static REGlobal *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}


#pragma mark - RSA加解密
/**
 * -------RSA 字符串公钥加密-------
 @param plaintext 明文，待加密的字符串
 @return 密文，加密后的字符串
 */
+ (NSString *)encryptString:(NSString *)plaintext;
{
    /*
     {
         "expirationTime":null,
         "publicKey":"",
         "type":0,
         "version":""
     }
     */
    NSString *publicKey = [[REGlobal sharedInstance].encryption getString:@"publicKey"];
    NSString *version = [[REGlobal sharedInstance].encryption getString:@"version"];
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",version,[PGGCryptoRSA encryptString:plaintext publicKey:publicKey]];
    return finalStr;
}
@end
