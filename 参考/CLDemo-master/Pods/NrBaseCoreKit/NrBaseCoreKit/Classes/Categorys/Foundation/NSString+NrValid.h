//
//  NSString+NrValid.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NrValid)
#pragma mark - 校验
/// 检测字符串是否包含中文
+( BOOL)nr_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)nr_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)nr_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)nr_isValidMobile:(NSString *)str;

/// 纯数字
+ (BOOL)nr_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)nr_isValidCharacterOrNumber:(NSString *)str;

/// 判断字符串全是空格or空
+ (BOOL)nr_isEmpty:(NSString *) str;

/// 是否是正确的邮箱
+ (BOOL)nr_isValidEmail:(NSString *)email;

/// 是否是正确的QQ
+ (BOOL)nr_isValidQQ:(NSString *)qq;

@end

NS_ASSUME_NONNULL_END
