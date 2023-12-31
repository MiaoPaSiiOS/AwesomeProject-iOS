//
//  DSDateFormatter.h
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSDateFormatter : NSObject

/**
 *  Use DateFormatter to transform dateString to specified date string.
 *
 *  @param dateString                Date string. (eg. 2015-06-26 08:08:08)
 *  @param inputDateStringFormatter  Input date string formatter. (eg. yyyy-MM-dd HH:mm:ss)
 *  @param outputDateStringFormatter Output date string formatter. (eg. yy/MM/dd)
 *
 *  @return Specified date string.
 */
+ (NSString *)dateFormatterWithInputDateString:(NSString *)dateString
                      inputDateStringFormatter:(NSString *)inputDateStringFormatter
                     outputDateStringFormatter:(NSString *)outputDateStringFormatter;

/**
 *  Use DateFormatter to transform dateString to specified date string.
 *
 *  @param dateString                 Date string. (eg. 2015-06-26 08:08:08)
 *  @param inputDateStringFormatter   Input date string formatter. (eg. yyyy-MM-dd HH:mm:ss)
 *  @param outputDateStringFormatter  Output date string formatter. (eg. yy/MM/dd)
 *  @param configOutputFormatterBlock The block to config NSDateFormatter.
 *
 *  @return Specified date string.
 */
+ (NSString *)dateFormatterWithInputDateString:(NSString *)dateString
                      inputDateStringFormatter:(NSString *)inputDateStringFormatter
                     outputDateStringFormatter:(NSString *)outputDateStringFormatter
                         configOutputFormatter:(void (^)(NSDateFormatter *outputFormatter))configOutputFormatterBlock;

/**
 *  Use DateFormatter to transform dateString to NSDate.
 *
 *  @param dateString               Date string. (eg. 2015-06-26 08:08:08)
 *  @param inputDateStringFormatter Input date string formatter. (eg. yyyy-MM-dd HH:mm:ss)
 *
 *  @return NSDate object.
 */
+ (NSDate *)dateFormatterWithInputDateString:(NSString *)dateString
                    inputDateStringFormatter:(NSString *)inputDateStringFormatter;

/**
 *  Use DateFormatter to transform date to specified date string.
 *
 *  @param date                      NSDate object.
 *  @param outputDateStringFormatter Output date string formatter. (eg. yy/MM/dd)
 *
 *  @return Specified date string.
 */
+ (NSString *)dateStringFromDate:(NSDate *)date
       outputDateStringFormatter:(NSString *)outputDateStringFormatter;

/**
 *  Use DateFormatter to transform date to specified date string.
 *
 *  @param date                       NSDate object.
 *  @param outputDateStringFormatter  Output date string formatter. (eg. yy/MM/dd)
 *  @param configOutputFormatterBlock The block to config NSDateFormatter.
 *
 *  @return Specified date string.
 */
+ (NSString *)dateStringFromDate:(NSDate *)date
       outputDateStringFormatter:(NSString *)outputDateStringFormatter
           configOutputFormatter:(void (^)(NSDateFormatter *outputFormatter))configOutputFormatterBlock;

@end

