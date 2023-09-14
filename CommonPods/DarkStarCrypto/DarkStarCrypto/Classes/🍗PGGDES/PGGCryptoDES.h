//
//  PGGCryptoDES.h
//  PGGCrypto
//
//  Created by 陈鹏 on 2017/10/24.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//  GitHub地址  https://github.com/penghero/PGGCrypto.git



@interface PGGCryptoDES : NSObject

// 加密
+(NSString *)Encrypt:(NSString *)input;

+(NSString *)Encrypt:(NSString *)input withKey:(NSString *)key;

// 解密
+(NSString *)Decrypt:(NSString *)input;

+(NSString *)Decrypt:(NSString *)input withKey:(NSString *)key;

@end
