//
//  NSString+NrDeal.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NrDeal)
#pragma mark - 空格处理
/// 消除收尾空格
- (NSString *)nr_removeBothEndsWhitespace;
/// 消除收尾空格+换行符
- (NSString *)nr_removeBothEndsWhitespaceAndNewline;
/// 消除收尾空格
- (NSString *)nr_trimWhitespace;
/// 消除所有空格
- (NSString *)nr_trimAllWhitespace;

#pragma mark - 字符串截取
/// 获取后6位
/// @param string string description
+ (NSString *)nr_getLastSixChar:(NSString *)string;

/// 获取后4位
/// @param string string description
+ (NSString *)nr_getLastFourChar:(NSString *)string;

/// 获取前4位
/// @param string string description
+ (NSString *)nr_getFirstFourChar:(NSString *)string;

/// 每4位加一个空格
/// @param string string description
+ (NSString *)nr_insertSpace:(NSString *)string;

/// 保留最后数字, 其他替换成 *
/// @param string 原始字符串
/// @param end 保留的最后位数,  e.g. end = 4,  12345678 -> ****5678
+ (NSString *)nr_replacedByStar:(NSString *)string end:(NSUInteger)end;

/// 保留开始和最后数字, 其他替换成 *
/// @param string 原始字符串
/// @param begin 保留的开始的位数
/// @param end 保留的最后位数
/// e.g.  bagin = 2, end = 3,   12345678 -> 12***678
+ (NSString *)nr_replacedByStar:(NSString *)string begin:(NSUInteger)begin end:(NSUInteger)end;


#pragma mark - 字符串查找
- (NSArray <NSValue *> *)nr_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range;




#pragma mark - 金额处理
/// 金额处理 e.g. 50000变为50,000.00
- (NSString *)nr_transformToMoneyType;



#pragma mark - 其他
/// url参数拼接
/// @param parameters url参数
- (NSString *)nr_urlStringAppendParameters:(NSDictionary *)parameters;

/// Transform hex string like '0xF181' to unicode '\u{F181}'.
/// @param hexString The hex string like '0xF181'
+ (NSString *)nr_unicodeWithHexString:(NSString *)hexString;


- (NSString *)nr_md5;

@end

NS_ASSUME_NONNULL_END
