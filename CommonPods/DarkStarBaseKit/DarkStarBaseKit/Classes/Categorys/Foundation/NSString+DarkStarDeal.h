//
//  NSString+DarkStarDeal.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DarkStarDeal)
#pragma mark - 空格处理
/// 消除收尾空格
- (NSString *)ds_removeBothEndsWhitespace;
/// 消除收尾空格+换行符
- (NSString *)ds_removeBothEndsWhitespaceAndNewline;
/// 消除收尾空格
- (NSString *)ds_trimWhitespace;
/// 消除所有空格
- (NSString *)ds_trimAllWhitespace;

#pragma mark - 字符串截取
/// 获取后6位
/// @param string string description
+ (NSString *)ds_getLastSixChar:(NSString *)string;

/// 获取后4位
/// @param string string description
+ (NSString *)ds_getLastFourChar:(NSString *)string;

/// 获取前4位
/// @param string string description
+ (NSString *)ds_getFirstFourChar:(NSString *)string;

/// 每4位加一个空格
/// @param string string description
+ (NSString *)ds_insertSpace:(NSString *)string;

/// 保留最后数字, 其他替换成 *
/// @param string 原始字符串
/// @param end 保留的最后位数,  e.g. end = 4,  12345678 -> ****5678
+ (NSString *)ds_replacedByStar:(NSString *)string end:(NSUInteger)end;

/// 保留开始和最后数字, 其他替换成 *
/// @param string 原始字符串
/// @param begin 保留的开始的位数
/// @param end 保留的最后位数
/// e.g.  bagin = 2, end = 3,   12345678 -> 12***678
+ (NSString *)ds_replacedByStar:(NSString *)string begin:(NSUInteger)begin end:(NSUInteger)end;


#pragma mark - 字符串查找
- (NSArray <NSValue *> *)ds_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range;




#pragma mark - 金额处理
/// 金额处理 e.g. 50000变为50,000.00
- (NSString *)ds_transformToMoneyType;



#pragma mark - 其他
/// url参数拼接
/// @param parameters url参数
- (NSString *)ds_urlStringAppendParameters:(NSDictionary *)parameters;

/// Transform hex string like '0xF181' to unicode '\u{F181}'.
/// @param hexString The hex string like '0xF181'
+ (NSString *)ds_unicodeWithHexString:(NSString *)hexString;


- (NSString *)ds_md5;

+ (NSString *)stringWithUTF32Char:(UTF32Char)char32;

+ (NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;

- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

- (NSString *)stringByURLEncode;

- (NSString *)stringByURLDecode;

- (NSString *)stringByAppendingNameScale:(CGFloat)scale;
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;
- (CGFloat)pathScale;
@end

NS_ASSUME_NONNULL_END
