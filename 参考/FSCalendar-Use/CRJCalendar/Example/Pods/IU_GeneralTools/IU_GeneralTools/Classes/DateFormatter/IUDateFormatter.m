//
//  IUDateFormatter.m
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUDateFormatter.h"

@implementation IUDateFormatter

+ (NSString *)dateFormatterWithInputDateString:(NSString *)dateString
                      inputDateStringFormatter:(NSString *)inputDateStringFormatter
                     outputDateStringFormatter:(NSString *)outputDateStringFormatter {
    
    NSParameterAssert(dateString);
    NSParameterAssert(inputDateStringFormatter);
    NSParameterAssert(outputDateStringFormatter);
    
    NSString *outputString = nil;
    
    NSDateFormatter *inputFormatter  = [[NSDateFormatter alloc] init] ;
    inputFormatter.dateFormat        = inputDateStringFormatter;
    
    NSDate *date = [inputFormatter dateFromString:dateString];
    
    if (date) {
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        outputFormatter.dateFormat       = outputDateStringFormatter;
        outputString                     = [outputFormatter stringFromDate:date];
    }
    
    return outputString;
}

+ (NSString *)dateFormatterWithInputDateString:(NSString *)dateString
                      inputDateStringFormatter:(NSString *)inputDateStringFormatter
                     outputDateStringFormatter:(NSString *)outputDateStringFormatter
                         configOutputFormatter:(void (^)(NSDateFormatter *outputFormatter))configOutputFormatterBlock {
    
    NSParameterAssert(dateString);
    NSParameterAssert(inputDateStringFormatter);
    NSParameterAssert(outputDateStringFormatter);
    
    NSString *outputString = nil;
    
    NSDateFormatter *inputFormatter  = [[NSDateFormatter alloc] init] ;
    inputFormatter.dateFormat        = inputDateStringFormatter;
    
    NSDate *date = [inputFormatter dateFromString:dateString];
    
    if (date) {
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        outputFormatter.dateFormat       = outputDateStringFormatter;
        
        if (configOutputFormatterBlock) {
            
            configOutputFormatterBlock(outputFormatter);
        }
        
        outputString = [outputFormatter stringFromDate:date];
    }
    
    return outputString;
}

+ (NSDate *)dateFormatterWithInputDateString:(NSString *)dateString
                    inputDateStringFormatter:(NSString *)inputDateStringFormatter {
    
    NSParameterAssert(dateString);
    NSParameterAssert(inputDateStringFormatter);
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    inputFormatter.dateFormat       = inputDateStringFormatter;
    NSDate *date = [inputFormatter dateFromString:dateString];
    
    return date;
}

+ (NSString *)dateStringFromDate:(NSDate *)date
       outputDateStringFormatter:(NSString *)outputDateStringFormatter {
    
    NSParameterAssert(date);
    NSParameterAssert(outputDateStringFormatter);
    
    NSDateFormatter *outputFormatter  = [[NSDateFormatter alloc] init] ;
    outputFormatter.dateFormat        = outputDateStringFormatter;
    
    return [outputFormatter stringFromDate:date];
}

+ (NSString *)dateStringFromDate:(NSDate *)date
       outputDateStringFormatter:(NSString *)outputDateStringFormatter
           configOutputFormatter:(void (^)(NSDateFormatter *outputFormatter))configOutputFormatterBlock {
    
    NSParameterAssert(date);
    NSParameterAssert(outputDateStringFormatter);
    
    NSDateFormatter *outputFormatter  = [[NSDateFormatter alloc] init] ;
    outputFormatter.dateFormat        = outputDateStringFormatter;
    
    if (configOutputFormatterBlock) {
        
        configOutputFormatterBlock(outputFormatter);
    }
    
    return [outputFormatter stringFromDate:date];
}
@end
