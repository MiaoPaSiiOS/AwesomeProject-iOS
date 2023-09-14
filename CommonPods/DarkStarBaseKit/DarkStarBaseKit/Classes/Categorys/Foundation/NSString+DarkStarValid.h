//
//  NSString+DarkStarValid.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DarkStarValid)
#pragma mark - 校验
/// 检测字符串是否包含中文
+( BOOL)ds_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)ds_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)ds_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)ds_isValidMobile:(NSString *)str;

/// 纯数字
+ (BOOL)ds_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)ds_isValidCharacterOrNumber:(NSString *)str;

/// 判断字符串全是空格or空
+ (BOOL)ds_isEmpty:(NSString *) str;

/// 是否是正确的邮箱
+ (BOOL)ds_isValidEmail:(NSString *)email;

/// 是否是正确的QQ
+ (BOOL)ds_isValidQQ:(NSString *)qq;

@end

NS_ASSUME_NONNULL_END
