//
//  DSCommonMethods.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import "DSCommonMethods.h"

@implementation DSCommonMethods
#pragma mark - 颜色
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
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

/// RGBA 颜色
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    UIColor *color = [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)];
    return color;
}

/// RGB 颜色, alpha 默认为 1.0
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b{
    UIColor *color = [self RGBA:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0];
    return color;
}

+ (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

+ (UIColor *)colorWithColorString:(NSString *)color {
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
    
    return [self colorWithHexString:rgbString alpha:alpha / 255.0f];
}

#pragma mark - 设备常用参数
/// 屏幕宽度
+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
///主屏幕高度
+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}
///分辨率
+ (CGFloat)screenScale {
    return [[UIScreen mainScreen] scale];
}
/// 分割线的高度
+ (CGFloat)LINE_HEIGHT {
    return 1.0/[UIScreen mainScreen].scale;
}
/// 状态栏高度
+ (CGFloat)statusBarHeight {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
/// NaviBar内容高度
+ (CGFloat)naviBarContentHeight {
    return 44.0;
}
/// NaviBar 的高度, 已适配iPhone X
+ (CGFloat)naviBarHeight {
    return [self statusBarHeight] + [self naviBarContentHeight];
}
/// TabBar内容高度
+ (CGFloat)tabBarContentHeight {
    return 49.0;
}
/// TabBar 高度, 已适配iPhone X
+ (CGFloat)tabBarHeight {
    CGFloat result = [self tabBarContentHeight];
    if(@available(iOS 11.0, *)){
        result += [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    }
    return result;
}

#pragma mark - 系统判断
+ (BOOL)iOSSystem:(CGFloat)system {
    return (([[[UIDevice currentDevice] systemVersion] floatValue] >= system)? (YES):(NO));
}
/// iOS 8 判断
+ (BOOL)isIOS8Later {
    return [self iOSSystem:8.0];
}
/// iOS 9 判断
+ (BOOL)isIOS9Later {
    return [self iOSSystem:9.0];
}
/// iOS 10 判断
+ (BOOL)isIOS10Later {
    return [self iOSSystem:10.0];
}
/// iOS 11 判断
+ (BOOL)isIOS11Later {
    return [self iOSSystem:11.0];
}
/// iOS 11.2 判断
+ (BOOL)isIOS11_2Later {
    return [self iOSSystem:11.2];
}

#pragma mark - 机型判断
/// iPhoneX 判断
+ (BOOL)isIPHONEX {
    return ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO));
}

#pragma mark - UIWindow | UIViewController
+ (nullable UIWindow *)findWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (nullable UIViewController *)findTopViewController {
    UIWindow * window = [self findWindow];
    return [self findTopViewController:window.rootViewController];
}

+ (nullable UIViewController *)findTopViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self findTopViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self findTopViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self findTopViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

+ (nullable UIViewController *)findCurrentViewControllerAtView:(UIView *)view{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (id)nextResponder;
        }
    }
    return nil;
}

#pragma mark - NSString

/**
 判断对象是否存在, 是否为 NSString 类型

 @param obj 要判断的对象
 @return 对象为 NSString 类型: YES, 对象不存在或不是 NSString 类型: NO
 */
+(BOOL)isString:(id)obj {
    if (obj && [obj isKindOfClass:NSString.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSString 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isStringEmptyOrNil:(id)obj {
    if (!obj || ![self isString:(obj)] || [obj length] < 1) {
        return YES;
    } else {
        return NO;
    }
}

/**
 直接取值

 @param obj 要判断的对象
 @return 对象不存在 或不是 NSString 类型 或没有数据 或为 nil: 空字符串, 其他情况: 原值
 */
+(NSString* )safeString:(id)obj {
    if (obj && (NSNull *)obj != [NSNull null]) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj stringValue];
        } else if([obj isKindOfClass:[NSObject class]]){
            return [obj description];
        }
    }
    return @"";
}

#pragma mark - NSArray

/**
 判断对象是否存在, 是否为 NSArray 类型

 @param obj 要判断的对象
 @return 对象存在为 NSArray 类型: YES, 对象不存在或不是 NSArray 类型: NO
 */
+(BOOL)isArray:(id)obj {
    if (obj && [obj isKindOfClass:NSArray.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSArray 类型, 是否有数据 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSArray 类型 或数组为空 或为nil: YES, 其他情况: NO
 */
+(BOOL)isArrayEmptyOrNil:(id)obj {
    if (!obj || ![self isArray:(obj)] || [obj count] < 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NSDictionary


/**
 判断对象是否存在, 是否为 NSDictionary 类型

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型: YES, 对象不存在或不是 NSDictionary 类型: NO
 */
+(BOOL)isDictionary:(id)obj {
    if (obj && [obj isKindOfClass:NSDictionary.class]) {
        return YES;
    }
    return NO;
}

/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据

 @param obj 要判断的对象
 @return 对象存在为 NSDictionary 类型且字典不为空: 原对象字典, 其他情况: 空字典
 */
+(NSDictionary *)isEmptyDict:(id)obj {
    if(![self isDictEmptyOrNil:(obj)]){
        return obj;
    } else {
        return @{};
    }
}


/**
 判断对象是否存在, 是否为 NSDictionary 类型, 是否有数据, 是否为 nil
 
 @param obj 要判断的对象
 @return 对象不存在 或不是 NSDictionary 类型 或字典为空 或为 nil: YES, 其他情况: NO
 */
+(BOOL)isDictEmptyOrNil:(id)obj {
    if (!obj || ![self isDictionary:(obj)] || [obj allKeys].count < 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - JSON & STRING
+(NSDictionary*)JSON_OBJ_FROM_STRING:(NSString *)jsonString {
    if ([self isStringEmptyOrNil:(jsonString)]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parseError;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    if (parseError || ![self isDictionary:(JSONObject)]) {
        NSLog(@"json解析失败：%@",parseError);
        return nil;
    }
    return JSONObject;
}

+(NSString*)JSON_STRING_FROM_OBJ:(NSDictionary *)dic {
    if ([self isDictEmptyOrNil:(dic)]) {
        return nil;
    }
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        return nil;
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    if (parseError || !jsonData) {
        NSLog(@"json解析失败：%@",parseError);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end






