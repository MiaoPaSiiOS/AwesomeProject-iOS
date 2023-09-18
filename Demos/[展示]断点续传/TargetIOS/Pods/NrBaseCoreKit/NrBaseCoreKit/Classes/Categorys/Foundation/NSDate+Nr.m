//
//  NSDate+Nr.m
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/1/25.
//

#import "NSDate+Nr.h"

@implementation NSDate (Nr)

// 字符串转为北京时间NSDate
+ (NSDate *)nr_convertToBJDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (dateString.length == 8) {
        formatter.dateFormat = @"yyyyMMdd";
    } else if (dateString.length == 14) {
        formatter.dateFormat = @"yyyyMMddHHmmss";
    }
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *date = [formatter dateFromString:dateString];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    date = [date dateByAddingTimeInterval:interval];
    return date;
}

// 北京时间转换为字符串
- (NSString *)nr_bjDateConvertToStringWithDateFormatter:(NSString *)dateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormatter;
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    NSDate *date = [self dateByAddingTimeInterval:-interval];
    return [formatter stringFromDate:date];
}

// 计算两个日期间隔天数
+ (NSInteger)nr_calculateDayWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.day;
}

// 距离date为n天的日期
+ (NSDate *)nr_getDateFromDate:(NSDate *)date deltaDay:(NSInteger)deltaDay {
    if (deltaDay == 0) {
        return date;
    }
    NSDate *nextDate = [NSDate dateWithTimeInterval:24 * 60 * 60 * (deltaDay) sinceDate:date];
    return nextDate;
}

// 获取距离date为N个月日日期
+ (NSDate *)nr_getDateFromDate:(NSDate *)date deltaMonth:(NSInteger)deltaMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    dateComponents.month += 1;
    NSDate *nextDate = [calendar dateFromComponents:dateComponents];
    return nextDate;
}


/// 判断当前时间是否在起止时间之间
/// @param startStr 起始时间
/// @param endStr 结束时间
+ (BOOL)nr_judgeTimeByStartTime:(NSString *)startStr andEndTime:(NSString *)endStr
{
    //获取当前时间
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    NSDate *start = [dateFormat dateFromString:startStr];
    NSDate *expire = [dateFormat dateFromString:endStr];
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (NSComparisonResult)compareCurrentWithTime:(NSString *)timeStr {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *todayStr = [dateFormat stringFromDate:[NSDate date]];
    NSDate *today = [dateFormat dateFromString:todayStr];
    
    NSDate *date = [dateFormat dateFromString:timeStr];
    return [date compare:today];
}

+ (BOOL)nr_isBeforeCurrentWithTime:(NSString *)timeStr {
    if ([self compareCurrentWithTime:timeStr] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)nr_isAfterCurrentWithTime:(NSString *)timeStr {
    if ([self compareCurrentWithTime:timeStr] == NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}
@end
