//
//  DSHelper.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import "DSHelper.h"
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>

@implementation DSHelper

#pragma mark - NSBundle
+ (NSBundle *)findBundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName
{
    if (bundleName == nil || podName == nil) {
        return nil;
    }
    
    //去除文件后缀
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    
    if (!associateBundleURL) {//使用framework形式
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

+ (NSString *)pathForScaledResourceWithBundle:(NSBundle *)bundle name:(NSString *)name ofType:(NSString *)ext
{
    return [self pathForScaledResourceWithBundle:bundle name:name ofType:ext inDirectory:nil];
}

+ (NSString *)pathForScaledResourceWithBundle:(NSBundle *)bundle name:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [NSBundle pathForResource:name ofType:ext inDirectory:subpath];
    
    NSString *path = nil;
    NSArray *scales = [self preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        
        NSString *scaledName = ext.length ? [self string:name ByAppendingNameScale:scale] : [self string:name ByAppendingPathScale:scale];
        path = [NSBundle pathForResource:scaledName ofType:ext inDirectory:subpath];
        if (path) break;
    }
    return path;
}


+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    if (!name) return nil;
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (NSArray *)preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

+ (NSString *)string:(NSString *)str ByAppendingNameScale:(CGFloat)scale
{
    if (fabs(scale - 1) <= __FLT_EPSILON__ || str.length == 0 || [str hasSuffix:@"/"]) return str.copy;
    return [str stringByAppendingFormat:@"@%@x", @(scale)];
}

+ (NSString *)string:(NSString *)str ByAppendingPathScale:(CGFloat)scale
{
    if (fabs(scale - 1) <= __FLT_EPSILON__ || str.length == 0 || [str hasSuffix:@"/"]) return str.copy;
    NSString *ext = str.pathExtension;
    NSRange extRange = NSMakeRange(str.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [str stringByReplacingCharactersInRange:extRange withString:scaleStr];
}


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

#pragma mark - UIWindow | UIViewController
+ (UIWindow *)findWindow {
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

+ (UIViewController *)findTopViewController {
    UIWindow * window = [self findWindow];
    return [self findTopViewController:window.rootViewController];
}

+ (UIViewController *)findTopViewController:(UIViewController *)rootViewController {
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

+ (UIViewController *)findCurrentViewControllerAtView:(UIView *)view{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (id)nextResponder;
        }
    }
    return nil;
}

+ (UIViewController *)findPreviousViewController:(UIViewController *)viewController {
    if (viewController.navigationController.viewControllers && viewController.navigationController.viewControllers.count > 1 && viewController.navigationController.topViewController == viewController) {
        NSUInteger count = viewController.navigationController.viewControllers.count;
        return (UIViewController *)[viewController.navigationController.viewControllers objectAtIndex:count - 2];
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

#pragma mark - UIScrollView
+ (void)scrollToTop:(UIScrollView *)scrollView {
    [self scrollToTop:scrollView animated:YES];
}

+ (void)scrollToBottom:(UIScrollView *)scrollView {
    [self scrollToBottom:scrollView animated:YES];
}

+ (void)scrollToLeft:(UIScrollView *)scrollView {
    [self scrollToLeft:scrollView animated:YES];
}

+ (void)scrollToRight:(UIScrollView *)scrollView {
    [self scrollToRight:scrollView animated:YES];
}

+ (void)scrollToTop:(UIScrollView *)scrollView animated:(BOOL)animated {
    CGPoint off = scrollView.contentOffset;
    off.y = 0 - scrollView.contentInset.top;
    [scrollView setContentOffset:off animated:animated];
}

+ (void)scrollToBottom:(UIScrollView *)scrollView animated:(BOOL)animated {
    CGPoint off = scrollView.contentOffset;
    off.y = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom;
    [scrollView setContentOffset:off animated:animated];
}

+ (void)scrollToLeft:(UIScrollView *)scrollView animated:(BOOL)animated {
    CGPoint off = scrollView.contentOffset;
    off.x = 0 - scrollView.contentInset.left;
    [scrollView setContentOffset:off animated:animated];
}

+ (void)scrollToRight:(UIScrollView *)scrollView animated:(BOOL)animated {
    CGPoint off = scrollView.contentOffset;
    off.x = scrollView.contentSize.width - scrollView.bounds.size.width + scrollView.contentInset.right;
    [scrollView setContentOffset:off animated:animated];
}


#pragma mark - Alert
+ (void)showAlertControllerWithTitle:(id)title message:(id)message buttonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock
{
    [self showAlertControllerWithTitle:title message:message buttonTitles:btnTitleArr buttonColors:nil alertClick:clickBlock];
}

+ (void)showAlertControllerWithTitle:(id)title message:(id)message alertClick:(IUVoidBlock_int)clickBlock
{
    [self showAlertControllerWithTitle:title message:message buttonTitles:@[@"取消",@"确定"] buttonColors:nil alertClick:clickBlock];
}

+ (void)showAlertControllerWithTitle:(id)title message:(id)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr  alertClick:(IUVoidBlock_int)clickBlock
{
    // 判断是否为空，避免return
    if (title == nil) {
        title = @"";
    }
    if (message == nil) {
        message = @"";
    }
    // 判断 title 和 message 类型
    NSString *string = @"";
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:string];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string];
    NSMutableAttributedString *attributeMutableStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSArray *strClassArr = @[
        NSStringFromClass(string.class),
        NSStringFromClass(mutableStr.class)];
    NSArray *atrStrClassArr = @[
        NSStringFromClass(attributeStr.class),
        NSStringFromClass(attributeMutableStr.class)];
    
    NSArray *classArr = @[
        NSStringFromClass(string.class),
        NSStringFromClass(mutableStr.class),
        NSStringFromClass(attributeStr.class),
        NSStringFromClass(attributeMutableStr.class)];
    
    if (![classArr containsObject:NSStringFromClass([title class])] ||
        ![classArr containsObject:NSStringFromClass([message class])]) {
        NSLog(@"传入title或者message类型不对");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        // title根据类型赋值
        if ([strClassArr containsObject:NSStringFromClass([title class])]) {
            alertController.title = title;
        } else if ([atrStrClassArr containsObject:NSStringFromClass([title class])]) {
            [alertController setValue:title forKey:@"attributedTitle"];
        }
        // message根据类型赋值
        if ([strClassArr containsObject:NSStringFromClass([message class])]) {
            alertController.message = message;
        } else if ([atrStrClassArr containsObject:NSStringFromClass([message class])]) {
            [alertController setValue:message forKey:@"attributedMessage"];
        }
        
        // 按钮颜色处理
        NSArray *colors;
        if (btnColorArr.count == 0 || btnColorArr.count != btnTitleArr.count) {
            if (btnColorArr.count == 1) {
                colors = btnColorArr;
            } else {
                colors = nil;
            }
        } else {
            colors = btnColorArr;
        }
        
        for (int i = 0; i < btnTitleArr.count; i++) {
            NSString *title = btnTitleArr[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (clickBlock) {
                    int index = (int)[btnTitleArr indexOfObject:action.title];
                    clickBlock(index);
                }
            }];
            if (colors.count != 0) {
                if (colors.count == 1) {
                    [action setValue:[colors firstObject] forKey:@"_titleTextColor"];
                } else {
                    [action setValue:colors[i] forKey:@"_titleTextColor"];
                }
            }
            [alertController addAction:action];
        }
        [[self findTopViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - Alert Sheet
+ (void)showAlertSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr  alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock
{
    [self showAlertSheetWithTitle:nil message:title buttonTitles:btnTitleArr buttonColors:btnColorArr alertClick:clickBlock alertCancle:cancleBlock];
}

+ (void)showAlertSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock
{
    [self showAlertSheetWithTitle:nil message:title buttonTitles:btnTitleArr buttonColors:nil alertClick:clickBlock alertCancle:cancleBlock];
}

+ (void)showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock
{
    [self showAlertSheetWithTitle:nil message:nil buttonTitles:btnTitleArr buttonColors:btnColorArr alertClick:clickBlock alertCancle:cancleBlock];
}

+ (void)showAlertSheetWithButtonTitles:(NSArray *)btnTitleArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock
{
    [self showAlertSheetWithTitle:nil message:nil buttonTitles:btnTitleArr buttonColors:nil alertClick:clickBlock alertCancle:cancleBlock];
}

+ (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)btnTitleArr buttonColors:(NSArray *)btnColorArr alertClick:(IUVoidBlock_int)clickBlock alertCancle:(IUVoidBlock)cancleBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (cancleBlock) {
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                cancleBlock();
            }];
            [alertController addAction:cancleAction];
        }
        
        NSArray *colors;
        if (btnColorArr.count == 0 || btnColorArr.count != btnTitleArr.count) {
            if (btnColorArr.count == 1) {
                colors = btnColorArr;
            } else {
                colors = nil;
            }
        } else {
            colors = btnColorArr;
        }
        
        for (int i = 0; i < btnTitleArr.count; i++) {
            NSString *title = btnTitleArr[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (clickBlock) {
                    int index = (int)[btnTitleArr indexOfObject:action.title];
                    clickBlock(index);
                }
            }];
            if (colors.count != 0) {
                if (colors.count == 1) {
                    [action setValue:[colors firstObject] forKey:@"_titleTextColor"];
                } else {
                    [action setValue:colors[i] forKey:@"_titleTextColor"];
                }
            }
            [alertController addAction:action];
        }
        [[self findTopViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - 添加渐变色
+ (void)addHorizontalGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    [self addGradientLayerToView:view frame:view.bounds startColor:startColor endColor:endColor startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
}

+ (void)addVerticalGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    [self addGradientLayerToView:view frame:view.bounds startColor:startColor endColor:endColor startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1.0)];
}

+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    if (!startColor || !endColor) return;
    [self addGradientLayerToView:view
                           frame:view.bounds
                          colors:@[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor]
                      startPoint:startPoint
                        endPoint:endPoint
                    cornerRadius:0];
}

+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame colors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(CGFloat)cornerRadius
{
    if ([DSHelper isArrayEmptyOrNil:colors]) return;
    
    [self removeGradientLayerToView:view];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = frame;
    gradientLayer.cornerRadius = cornerRadius;
    gradientLayer.masksToBounds = YES;
    [view.layer addSublayer:gradientLayer];
}

+ (void)addGradientLayerToView:(UIView *)view frame:(CGRect)frame colors:(NSArray *)colors endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth
{
    if ([DSHelper isArrayEmptyOrNil:colors]) return;

    [self removeGradientLayerToView:view];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer]; //添加渐变背景色
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = frame;
    gradientLayer.cornerRadius = cornerRadius;
    gradientLayer.masksToBounds = YES;

    CALayer *maskLayer = [CALayer layer]; //添加白色遮罩
    maskLayer.backgroundColor = UIColor.whiteColor.CGColor;
    maskLayer.masksToBounds = YES;
    maskLayer.cornerRadius = cornerRadius - borderWidth;
    maskLayer.frame = CGRectMake(borderWidth, borderWidth, frame.size.width - 2 * borderWidth, frame.size.height - 2 * borderWidth);
    [view.layer addSublayer:gradientLayer];
    [view.layer addSublayer:maskLayer];
}

+ (CAGradientLayer *)gradientLayerToView:(UIView *)view
{
    CAGradientLayer *gradlayer;
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            gradlayer = (CAGradientLayer *)layer;
            break;
        }
    }
    return gradlayer;
}

+ (void)removeGradientLayerToView:(UIView *)view
{
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark - 添加手势
// 添加Tap手势
+ (void)addTapGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

// 添加Pan手势
+ (void)addPanGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action {
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:target action:action];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

// 添加LongPress手势
+ (void)addLongPressGestureRecognizerToView:(UIView *)view target:(id)target action:(SEL)action {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:longPress];
}

#pragma mark - 添加圆角
+ (void)addAllCornerToView:(UIView *)view radius:(CGFloat)radius
{
    [self addCornerToView:view corner:UIRectCornerAllCorners radius:radius];
}

+ (void)addAllCornerToView:(UIView *)view rect:(CGRect)rect radius:(CGFloat)radius
{
    [self addRectCorneToView:view rect:rect corner:UIRectCornerAllCorners radius:radius];
}

+ (void)addCornerToView:(UIView *)view corner:(UIRectCorner)corner radius:(CGFloat)radius
{
    [self addRectCorneToView:view rect:view.bounds corner:corner radius:radius];
}

+ (void)addRectCorneToView:(UIView *)view rect:(CGRect)rect corner:(UIRectCorner)corner radius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}

+ (void)setCornerWithLeftTopCorner:(CGFloat)leftTop
                    rightTopCorner:(CGFloat)rigtTop
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight
                              view:(UIView *)view
                             frame:(CGRect)frame
{
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(bottemRight, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - bottemRight, height)];
    
    [maskPath addQuadCurveToPoint:CGPointMake(width, height- bottemRight) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, rigtTop)]; //右边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width - rigtTop, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(leftTop, 0)]; //顶部直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(0, leftTop) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - bottemLeft)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(bottemLeft, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
#pragma mark - UIImage
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 屏幕截图
+ (UIImage *)snapshotForView:(UIView *)view
{
    /*
    renderInContext:方式实际上是通过遍历UIView的layer tree进行渲染，但是它不支持动画的渲染，它的的性能会和layer tree的复杂度直接关联
    drawViewHierarchyInRect:afterScreenUpdates:的api是苹果基于UIView的扩展，与第一种方式不同，这种方式是直接获取当前屏幕的“快照”，此种方式的性能与UIView的frame大小直接关联。
    在UIView内容不是很“长”的情况下，第二种方式有内存优势的；但是随着UIView的内容增加，第二种方式会有较大增加；
             第一种(内存)           第二种(内存)       第一种(耗时)        第二种(耗时)
    1~2屏    28.4323M             8.1431M           195.765972ms      271.728992ms
    2~3屏    36.0012M             8.5782M           221.408010ms      280.839980ms
    5屏以上   38.511718M           23.1875M          448.800981ms      565.396011ms
    */
    if ([view isKindOfClass:[UIScrollView class]]) {
        CGRect rect = view.frame;
        rect.size = ((UIScrollView *)view).contentSize;
        
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [view.layer renderInContext:context];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    } else {
        /*
         * 参数一: 指定将来创建出来的bitmap的大小
         * 参数二: 设置透明YES代表透明，NO代表不透明
         * 参数三: 代表缩放,0代表不缩放
         */
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
        
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return image;
    }
}

+ (NSData *)snapshotPDFForView:(UIView *)view
{
    CGRect bounds = view.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [view.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

+ (UIImage *)cutoutInViewWithRect:(CGRect)rect forView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.layer.contents = nil;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    img = [UIImage imageWithCGImage:imageRef];
    return img;
}

#pragma mark - 毛玻璃
+ (void)addBlurEffectWith:(UIBlurEffectStyle)blurStyle forView:(UIView *)view
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:blurStyle];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview:effectView];
}

+ (UIImage *)blurImage:(UIImage *)image WithCoreImageBlurNumber:(CGFloat)blurNum
{
    if (self == nil) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    // 创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 设置滤镜输入的图像
    // 注意：这里的key可以写kCIInputImageKey，也可以写@“inputImage”
    [filter setValue:inputImage forKey:kCIInputImageKey];
    // 设置高斯模糊数值
    // 这里的key可以写kCIInputRadiusKey，也可以写@“inputRadius”。
    [filter setValue:@(blurNum) forKey:kCIInputRadiusKey];
    // 处理后图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (UIImage *)blurImage:(UIImage *)image WithAccelerateBlurValue:(CGFloat)blurValue {
    if (self == nil) {
        return nil;
    }
    if (blurValue < 0.f || blurValue > 1.f) {
        blurValue = 0.5f;
    }
    int boxSize = (int)(blurValue * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)applyLightEffectImage:(UIImage *)image
{
    UIColor *tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurImage:image blurRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

+ (UIImage *)applyExtraLightEffectImage:(UIImage *)image
{
    UIColor *tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurImage:image blurRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

+ (UIImage *)applyDarkEffectImage:(UIImage *)image
{
    UIColor *tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurImage:image blurRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

+ (UIImage *)applyTintEffectImage:(UIImage *)image tintColor:(UIColor*)tintColor
{
    const CGFloat effectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    NSInteger componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount == 2){
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]){
            effectColor =[UIColor colorWithWhite:b alpha:effectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]){
            effectColor =[UIColor colorWithRed:r green:g blue:b alpha:effectColorAlpha];
        }
    }
    return [self applyBlurImage:image blurRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

+ (UIImage *)applyBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage
{
    // Check pre-conditions.
    if(image.size.width < 1 || image.size.height < 1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",image.size.width,image.size.height,image);
        return nil;
    }
    if(!image.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage && !maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect ={CGPointZero,image.size};
    UIImage *effectImage = image;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange){
        UIGraphicsBeginImageContextWithOptions(image.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-image.size.height);
        CGContextDrawImage(effectInContext, imageRect,image.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(image.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext =UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2!=1){
                radius +=1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
        }
        
        if(hasSaturationChange){
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[]={
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize =sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i =0; i < matrixSize;++i){
                saturationMatrix[i]=(int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur){
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(image.size, NO,[[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext,1.0,-1.0);
    CGContextTranslateCTM(outputContext,0,-image.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect,image.CGImage);
    // Draw effect image.
    if(hasBlur){
        CGContextSaveGState(outputContext);
        if(maskImage){
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if(tintColor){
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage*outputImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

#pragma mark - 颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, MAX(1.0f, imageSize.width), MAX(1.0f, imageSize.height));
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - 生成渐变色的图片
+ (UIImage *)gradientColorImageWithSize:(CGSize)size colors:(NSArray *)colors startPoint:(CGPoint)startP endPoint:(CGPoint)endP
{
    if (colors == nil || colors.count == 0) {
        return nil;
    }
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start = startP;
    CGPoint end = endP;
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 生成带圆角的颜色图片
+ (UIImage *)squareImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize
{
    return [self cornerRadiusImageWithColor:color targetSize:targetSize cornerRadius:0];
}

+ (UIImage *)cornerRadiusImageWithColor:(UIColor *)color targetSize:(CGSize)targetSize cornerRadius:(CGFloat)cornerRadius
{
    return [self cornerRadiusImageWithColor:color targetSize:targetSize corners:UIRectCornerAllCorners cornerRadius:cornerRadius backgroundColor:[UIColor whiteColor]];
}

+ (UIImage *)cornerRadiusImageWithColor:(UIColor *)tintColor targetSize:(CGSize)targetSize corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor
{
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, [UIScreen mainScreen].scale);
    
    CGRect targetRect = (CGRect){0, 0, targetSize.width, targetSize.height};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [tintColor CGColor]);
    CGContextFillRect(context, targetRect);

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (cornerRadius != 0 && cornerRadius > 0) {
        UIGraphicsBeginImageContextWithOptions(targetSize, YES, [UIScreen mainScreen].scale);

        if (backgroundColor) {
            [backgroundColor setFill];
            CGContextFillRect(UIGraphicsGetCurrentContext(), targetRect);
        }

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
        CGContextClip(UIGraphicsGetCurrentContext());
        [finalImage drawInRect:targetRect];
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return finalImage;
}

#pragma mark - 图片裁剪
+ (UIImage *)image:(UIImage *)image clipRect:(CGRect)clipRect
{
    CGSize imageSize = image.size;
    if (clipRect.origin.x > imageSize.width || clipRect.origin.y > imageSize.height) {
        return nil;
    }
    if (clipRect.origin.x + clipRect.size.width > imageSize.width) {
        clipRect.size.width = imageSize.width - clipRect.origin.x;
    }
    if (clipRect.origin.y + clipRect.size.height > imageSize.height) {
        clipRect.size.height = imageSize.height - clipRect.origin.y;
    }
    UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], clipRect)];
    return newImage;
}

+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius
{
    return [self image:image radius:radius corners:UIRectCornerAllCorners borderWidth:0 borderColor:[UIColor whiteColor] borderLineJoin:kCGLineJoinMiter];
}

+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    return [self image:image radius:radius corners:UIRectCornerAllCorners borderWidth:borderWidth borderColor:borderColor borderLineJoin:kCGLineJoinMiter];
}

+ (UIImage *)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    if (image.size.width == image.size.height) {
        return [self image:image radius:image.size.width/2 borderWidth:borderWidth borderColor:borderColor];
    } else {
        CGFloat min = MIN(image.size.width, image.size.height);
        CGFloat pointX = (image.size.width - min) / 2;
        CGFloat pointY = (image.size.height - min) / 2;
        UIImage *newImage = [self image:image clipRect:CGRectMake(pointX, pointY, min, min)];
        return [self image:newImage radius:min/2 borderWidth:borderWidth borderColor:borderColor];
    }
}

+ (UIImage *)image:(UIImage *)image radius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin
{
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(image.size.width, image.size.height);
    if (borderWidth < minSize / 2) {
        // 先绘制图片
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth/2, borderWidth/2) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, image.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        // 再绘制边框
        CGFloat strokeInset = (floor(borderWidth * image.scale) + 0.5) / image.scale/2;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > image.scale / 2 ? radius - image.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 图片@拉伸
+ (UIImage *)resizableImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *newimage = [image resizableImageWithCapInsets:edgeInsets resizingMode:resizingMode];
    return newimage;
}

+ (UIImage *)stretchableImage:(UIImage *)image left:(NSInteger)left top:(NSInteger)top
{
    UIImage *newimage = [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    return newimage;
}

+ (UIImage *)changeSizeImage:(UIImage *)image newSize:(CGSize)newSize isScale:(BOOL)isScale
{
    UIImage *newImage;
    if (isScale) {
        CGFloat width = CGImageGetWidth(image.CGImage);
        CGFloat height = CGImageGetHeight(image.CGImage);
        
        float verticalRadio = newSize.height*1.0/height;
        float horizontalRadio = newSize.width*1.0/width;
        
        float radio = 1;
        if(verticalRadio>1 && horizontalRadio>1)
        {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
        }
        
        width = width*radio;
        height = height*radio;
        
        int xPos = (newSize.width - width)/2;
        int yPos = (newSize.height-height)/2;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(newSize);
        
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(xPos, yPos, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    } else {
        UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];//根据新的尺寸画出传过来的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
        UIGraphicsEndImageContext();//关闭当前环境
    }
    return newImage;
}

+ (UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock
{
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithEmoji:(NSString *)emoji size:(CGFloat)size {
    if (emoji.length == 0) return nil;
    if (size < 1) return nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CTFontRef font = CTFontCreateWithName(CFSTR("AppleColorEmoji"), size * scale, NULL);
    if (!font) return nil;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:emoji attributes:@{ (__bridge id)kCTFontAttributeName:(__bridge id)font, (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor whiteColor].CGColor }];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, size * scale, size * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)str);
    CGRect bounds = CTLineGetBoundsWithOptions(line, kCTLineBoundsUseGlyphPathBounds);
    CGContextSetTextPosition(ctx, 0, -bounds.origin.y);
    CTLineDraw(line, ctx);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    
    CFRelease(font);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    if (line)CFRelease(line);
    if (imageRef) CFRelease(imageRef);
    
    return image;
}

#pragma mark - PHAsset
+ (PHAsset *)latestAsset
{
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}

+ (void)latestOriginImageWithCompleteBlock:(void (^)(UIImage *))block
{
    PHAsset *asset = [self latestAsset];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (block) {
            block(result);
        }
    }];
    
}

+ (void)latestImageWithSize:(CGSize)size completeBlock:(void (^)(UIImage *))block
{
    PHAsset *asset = [self latestAsset];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (block) {
            block(result);
        }
    }];
}


#pragma mark - NSTimer
+ (void)_yy_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_yy_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_yy_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

#pragma mark - 文本校验
/// 检测字符串是否包含中文
+(BOOL)checkIsContainChinese:(NSString *)string {
    for(int i=0; i< [string length];i++)
    {
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

/// 整形
+ (BOOL)checkIsPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/// 浮点型
+ (BOOL)checkIsPureFloat:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/// 有效的手机号码
+ (BOOL)checkIsValidMobile:(NSString *)string {
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

/// 纯数字
+ (BOOL)checkIsPureDigitCharacters:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0) return NO;
    
    return YES;
}

/// 字符串为字母或者数字
+ (BOOL)checkIsValidCharacterOrNumber:(NSString *)string {
    // 编写正则表达式：只能是数字或英文，或两者都存在
    NSString *regex = @"^[a-z0－9A-Z]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

///判断是否全是空格
+ (BOOL)checkIsEmpty:(NSString *)string {
    if (!string) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

/// 是否是正确的邮箱
+ (BOOL)checkIsValidEmail:(NSString *)string {
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:string];
}

/// 是否是正确的QQ
+ (BOOL)checkIsValidQQ:(NSString *)string {
    NSString *regex =@"^[1-9][0-9]{4,9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

#pragma mark - NSDate
+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"M/d/yy"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // local time error
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60) {
        return [NSString stringWithFormat:@"%ds",(int)(delta)];
    } else if (delta < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(delta / 60.0)];
    } else if (delta < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(delta / 60.0 / 60.0)];
    } else if (delta < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%dd", (int)(delta / 60.0 / 60.0 / 24.0)];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}


#pragma mark - ???
+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    if (number <= 999) return [NSString stringWithFormat:@"%d",(int)number];
    if (number <= 9999) return [NSString stringWithFormat:@"%d,%3.3d",(int)(number / 1000), (int)(number % 1000)];
    if (number < 1000 * 1000) return [NSString stringWithFormat:@"%.1fK", number / 1000.0];
    if (number < 1000 * 1000 * 1000) return [NSString stringWithFormat:@"%.1fM", number / 1000.0 / 1000.0];
    return [NSString stringWithFormat:@"%.1fB", number / 1000.0 / 1000.0 / 1000.0];
}

@end






