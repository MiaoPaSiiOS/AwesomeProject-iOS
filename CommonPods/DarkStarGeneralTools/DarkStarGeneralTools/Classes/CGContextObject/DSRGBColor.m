//
//  DSRGBColor.m
//  DSCGContext_Example
//
//  Created by zhuyuhui on 2020/9/4.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "DSRGBColor.h"

@implementation DSRGBColor

+ (instancetype)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    DSRGBColor *color = [[[self class] alloc] init];
    
    color.red   = red;
    color.green = green;
    color.blue  = blue;
    color.alpha = alpha;
    
    return color;
}

+ (instancetype)colorWithUIColor:(UIColor *)color {

    DSRGBColor *tmpColor = [[[self class] alloc] init];
    
    CGFloat red   = 0;
    CGFloat green = 0;
    CGFloat blue  = 0;
    CGFloat alpha = 0;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    tmpColor.red   = red;
    tmpColor.green = green;
    tmpColor.blue  = blue;
    tmpColor.alpha = alpha;
    
    return tmpColor;
}

+ (instancetype)randomColor {

    DSRGBColor *color = [[[self class] alloc] init];
    
    color.red   = arc4random() % 256 / 255.f;
    color.green = arc4random() % 256 / 255.f;
    color.blue  = arc4random() % 256 / 255.f;
    color.alpha = arc4random() % 256 / 255.f;
    
    return color;
}

+ (instancetype)randomColorWithAlpha:(CGFloat)alpha {
    
    DSRGBColor *color = [[[self class] alloc] init];
    
    color.red   = arc4random() % 256 / 255.f;
    color.green = arc4random() % 256 / 255.f;
    color.blue  = arc4random() % 256 / 255.f;
    color.alpha = (alpha < 0 || alpha > 1) ? 1 : alpha;
    
    return color;
}

@end
