//
//  NSDate+Nr.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Nr)
// 字符串转为北京时间NSDate   支持yyyyMMdd yyyyMMddHHmmss
+ (NSDate *)nr_convertToBJDate:(NSString *)dateString;

// 北京时间转换为字符串
- (NSString *)nr_bjDateConvertToStringWithDateFormatter:(NSString *)dateFormatter;

// 计算两个日期间隔天数
+ (NSInteger)nr_calculateDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

// 距离date为n天的日期
+ (NSDate *)nr_getDateFromDate:(NSDate *)date deltaDay:(NSInteger)deltaDay;

// 获取距离date为N个月的日期
+ (NSDate *)nr_getDateFromDate:(NSDate *)date deltaMonth:(NSInteger)deltaMonth;

/// 判断当前时间是否在起止时间之间
/// @param startStr 起始时间
/// @param endStr 结束时间
+ (BOOL)nr_judgeTimeByStartTime:(NSString *)startStr andEndTime:(NSString *)endStr;


//是否在当前时间之前
+ (BOOL)nr_isBeforeCurrentWithTime:(NSString *)timeStr;
//是否在当前时间之后
+ (BOOL)nr_isAfterCurrentWithTime:(NSString *)timeStr;

@end

NS_ASSUME_NONNULL_END
