//
//  NSString+RE.h
//  IHome4Phone
//
//  Created by sean on 2016/4/5.
//  Copyright © 2016年 RE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RE)

#pragma mark  ------- MD5 -------
- (NSString *)stringFromMD5;
- (NSString *)re_md5:(NSString *)key;
- (NSString *)re_md5;
+ (NSString *)re_randomKey;

/**
 *  urlencoding
 */
- (NSString *)urlEncoding;
/**
 *  urldecoding
 */
- (NSString *)urlDecoding;
/**
 *  url encoding所有字符
 */
- (NSString *)urlEncodingAllCharacter;

/**
 *  NSString转为NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber *)toNumber;
@end
