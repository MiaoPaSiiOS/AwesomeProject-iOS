//
//  DSBase64.h
//  DarkStarCrypto
//
//  Created by zhuyuhui on 2022/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSBase64 : NSObject

#pragma mark - base64
/******************************************************************************
 函数名称 : + (NSString *)encodeBase64String:(NSString *)input
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)input    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString*)encodeBase64String:(NSString *)input;
/******************************************************************************
 函数名称 : + (NSString *)decodeBase64String:(NSString *)input
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)input  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
