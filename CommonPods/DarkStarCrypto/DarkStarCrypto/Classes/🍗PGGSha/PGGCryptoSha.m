//
//  PGGCryptoSha.m
//  PGGCrypto
//
//  Created by 陈鹏 on 2017/10/25.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//  GitHub地址  https://github.com/penghero/PGGCrypto.git

#import "PGGCryptoSha.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PGGCryptoSha

+ (NSString *)pgg_Sha1:(NSString *)input {
    if (!input)  return nil;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self SHAStringWithSourceData:data type:SHAType_sha1];;
}

+ (NSString *)pgg_Sha224:(NSString *)input {
    if (!input)  return nil;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self SHAStringWithSourceData:data type:SHAType_sha224];;
}

+ (NSString *)pgg_Sha256:(NSString *)input {
    if (!input)  return nil;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self SHAStringWithSourceData:data type:SHAType_sha256];;
}

+ (NSString *)pgg_Sha384:(NSString *)input {
    if (!input)  return nil;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self SHAStringWithSourceData:data type:SHAType_sha384];;
}

+ (NSString *)pgg_Sha512:(NSString *)input {
    if (!input)  return nil;
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self SHAStringWithSourceData:data type:SHAType_sha512];;
}

#pragma mark - private
+ (NSString *)SHAStringWithSourceData:(NSData *)data type:(SHAType)type {
    int shaDigestLength;
    switch (type) {
        case SHAType_sha1: shaDigestLength = CC_SHA1_DIGEST_LENGTH; break;
        case SHAType_sha224: shaDigestLength = CC_SHA224_DIGEST_LENGTH; break;
        case SHAType_sha256: shaDigestLength = CC_SHA256_DIGEST_LENGTH; break;
        case SHAType_sha384: shaDigestLength = CC_SHA384_DIGEST_LENGTH; break;
        case SHAType_sha512: shaDigestLength = CC_SHA512_DIGEST_LENGTH; break;
        default: break;
    }
     
    uint8_t digest[shaDigestLength];
    switch (type) {
        case SHAType_sha1: CC_SHA1(data.bytes, (CC_LONG)data.length, digest); break;
        case SHAType_sha224: CC_SHA224(data.bytes, (CC_LONG)data.length, digest); break;
        case SHAType_sha256: CC_SHA256(data.bytes, (CC_LONG)data.length, digest); break;
        case SHAType_sha384: CC_SHA384(data.bytes, (CC_LONG)data.length, digest); break;
        case SHAType_sha512: CC_SHA512(data.bytes, (CC_LONG)data.length, digest); break;
        default: break;
    }
     
    NSMutableString* output = [NSMutableString stringWithCapacity:shaDigestLength * 2];
    for(int i = 0; i < shaDigestLength; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end
