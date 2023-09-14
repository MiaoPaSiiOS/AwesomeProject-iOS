//
//  UIColor+DarkStar.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/7.
//

#import "UIColor+DarkStar.h"

@implementation UIColor (DarkStar)

//默认alpha值为1
+ (UIColor *)ds_colorWithHexString:(NSString *)color {
    return [self ds_colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)ds_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    // 删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 字符串应该是6个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    // 截取字符串后，正确的字符串应该是6个字符
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // 将字符串拆分成r, g, b三个子字符串
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // 扫描16进制到int
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha];
}

#pragma mark - string -> color
+ (UIColor *)ds_colorWithColorString:(NSString *)color {
    // 删除字符串中的空格
    NSString * cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // 字符串应该是8个字符
    if ([cString length] < 8) {
        return [UIColor clearColor];
    }
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    // 截取字符串后，正确的字符串应该是8个字符
    if ([cString length] != 8) {
        return [UIColor clearColor];
    }
    
    // 将字符串拆分成alpha和rgb两个子字符串
    //alpha
    NSString * alphaString = [cString substringWithRange:NSMakeRange(0, 2)];
    //rgb
    NSString * rgbString = [cString substringFromIndex:2];
    
    // 扫描16进制到int
    unsigned int alpha;
    [[NSScanner scannerWithString:alphaString] scanHexInt:&alpha];
    
    return [self ds_colorWithHexString:rgbString alpha:alpha / 255.0f];
}

+ (UIColor *)ds_randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

@end
