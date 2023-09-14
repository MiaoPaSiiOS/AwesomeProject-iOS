//
//  DataEncrypt.m
//  PufaBankMobile
//
//  Created by P&C on 10-12-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataEncrypt.h"
#import <DarkStarCrypto/DarkStarCrypto.h>

#define DESKEY @"BOCD-P&C"

@implementation DataEncrypt

// DES加密
+(NSString *)Encrypt:(NSString *)inputString
{
    
    return [PGGCryptoDES Encrypt:inputString withKey:DESKEY];
}

// DES加密
+(NSString *)Encrypt:(NSString *)inputString withKey:(NSString *)key
{
	return [PGGCryptoDES Encrypt:inputString withKey:key];
}

// DES解密
+(NSString *)Decrypt:(NSString *)encryptString
{
    return [PGGCryptoDES Decrypt:encryptString withKey:DESKEY];
}

// DES解密
+(NSString *)Decrypt:(NSString *)encryptString withKey:(NSString *)key
{
    return [PGGCryptoDES Decrypt:encryptString withKey:key];
}


@end
