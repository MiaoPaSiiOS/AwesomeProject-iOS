//
//  UIColor+DSGray.m
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import "UIColor+DSGray.h"
#import "DSGrayUtil.h"

@implementation UIColor (DSGray)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class cls = object_getClass(self);
        
        //将系统提供的colorWithRed:green:blue:alpha:替换掉
        Method originMethod = class_getClassMethod(cls, @selector(colorWithRed:green:blue:alpha:));
        Method swizzledMethod = class_getClassMethod(cls, @selector(lg_colorWithRed:green:blue:alpha:));
        
        [DSGrayUtil swizzleMethodWithOriginSel:@selector(colorWithRed:green:blue:alpha:) oriMethod:originMethod swizzledSel:@selector(lg_colorWithRed:green:blue:alpha:) swizzledMethod:swizzledMethod oriClass:cls];
        
        //将系统提供的colors也替换掉
        NSArray *array = [NSArray arrayWithObjects:@"redColor", @"greenColor", @"blueColor", @"cyanColor", @"yellowColor", @"magentaColor", @"orangeColor", @"purpleColor", @"brownColor", @"systemBlueColor", @"systemGreenColor", nil];
        
        for (int i = 0; i < array.count; i++) {
            SEL sel = NSSelectorFromString(array[i]);
            SEL lg_sel = NSSelectorFromString([NSString stringWithFormat:@"lg_%@", array[i]]);
            Method originMethod = class_getClassMethod(cls, sel);
            Method swizzledMethod = class_getClassMethod(cls, lg_sel);
            [DSGrayUtil swizzleMethodWithOriginSel:sel oriMethod:originMethod swizzledSel:lg_sel swizzledMethod:swizzledMethod oriClass:cls];
        }
    });
}

+ (UIColor *)lg_redColor {
    // 1.0, 0.0, 0.0 RGB
    UIColor *color = [self lg_redColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_greenColor {
    // 0.0, 1.0, 0.0 RGB
    UIColor *color = [self lg_greenColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_blueColor {
    //0.0, 0.0, 1.0
    UIColor *color = [self lg_blueColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_cyanColor {
    // 0.0, 1.0, 1.0
    UIColor *color = [self lg_cyanColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.0 green:1.0 blue:1.0 alpha:1.0];
    }
    
    return color;
}

+ (UIColor *)lg_yellowColor {
    //1.0, 1.0, 0.0
    UIColor *color = [self lg_yellowColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_magentaColor {
    // 1.0, 0.0, 1.0
    UIColor *color = [self lg_magentaColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:1.0 green:0.0 blue:1.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_orangeColor {
    // 1.0, 0.5, 0.0
    UIColor *color = [self lg_orangeColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_systemBlueColor {
    UIColor *color = [self lg_systemBlueColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_systemGreenColor {
    UIColor *color = [self lg_systemGreenColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_purpleColor {
    // 0.5, 0.0, 0.5
    UIColor *color = [self lg_purpleColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.5 green:0.0 blue:0.5 alpha:1.0];
    }
    return color;
}

+ (UIColor *)lg_brownColor {
    // 0.6, 0.4, 0.2
    UIColor *color = [self lg_brownColor];
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:0.6 green:0.4 blue:0.2 alpha:1.0];
    }
    return color;
}

+ (instancetype)lg_colorWithRed:(CGFloat)r
                          green:(CGFloat)g
                           blue:(CGFloat)b
                          alpha:(CGFloat)a
{
    UIColor *color = [self lg_colorWithRed:r green:g blue:b alpha:a];
    if (r == 0 && g == 0 && b == 0) {
        return color;
    }
    if ([DSGrayManager shared].grayViewEnabled) {
        color = [DSGrayUtil grayColorFroRed:r green:g blue:b alpha:a];
    }
    return color;
}

@end
