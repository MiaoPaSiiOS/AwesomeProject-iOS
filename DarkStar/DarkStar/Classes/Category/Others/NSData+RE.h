//
//  NSData+RE.h
//  IHome4Phone
//
//  Created by YT on 2018/10/22.
//  Copyright © 2018年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (RE)

/**
 *  16进制字符串转NSData
 *
 */
+ (NSData *)dataWithHexString:(NSString *)hexString;

/**
 *  NSData转16进制字符串
 */
- (NSString *)hexString;


+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;


@end


