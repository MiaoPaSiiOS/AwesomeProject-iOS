//
//  IUNumberFormatter.m
//  CRJGeneralTools_Example
//
//  Created by zhuyuhui on 2020/9/12.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUNumberFormatter.h"

@implementation IUNumberFormatter

+ (NSString *)PercentStyleWithValue:(CGFloat)value
              maximumFractionDigits:(NSUInteger)maximumFractionDigits
              minimumFractionDigits:(NSUInteger)minimumFractionDigits
                       roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = NSNumberFormatterPercentStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *)PercentStyleWithNumberValue:(NSNumber *)value
                    maximumFractionDigits:(NSUInteger)maximumFractionDigits
                    minimumFractionDigits:(NSUInteger)minimumFractionDigits
                             roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = NSNumberFormatterPercentStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:value];
}

+ (NSString *)decimalStyleWithValue:(CGFloat)value
              maximumFractionDigits:(NSUInteger)maximumFractionDigits
              minimumFractionDigits:(NSUInteger)minimumFractionDigits
                       roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = NSNumberFormatterDecimalStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *)decimalStyleWithNumberValue:(NSNumber *)value
                    maximumFractionDigits:(NSUInteger)maximumFractionDigits
                    minimumFractionDigits:(NSUInteger)minimumFractionDigits
                             roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *numFormatter    = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle           = NSNumberFormatterDecimalStyle;
    numFormatter.maximumFractionDigits = maximumFractionDigits;
    numFormatter.minimumFractionDigits = minimumFractionDigits;
    numFormatter.roundingMode          = roundingMode;
    
    return [numFormatter stringFromNumber:value];
}
@end
