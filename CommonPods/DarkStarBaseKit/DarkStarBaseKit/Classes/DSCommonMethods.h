//
//  DSCommonMethods.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCommonMethods : NSObject
#pragma mark - 颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)RGBA:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
+ (UIColor *)colorWithColorString:(NSString *)colorString;
+ (UIColor *)randomColor;

#pragma mark - 设备常用参数
/// 屏幕宽度
+ (CGFloat)screenWidth;
///主屏幕高度
+ (CGFloat)screenHeight;
///分辨率
+ (CGFloat)screenScale;
/// 分割线的高度
+ (CGFloat)LINE_HEIGHT;
/// 状态栏高度
+ (CGFloat)statusBarHeight;
/// NaviBar内容高度
+ (CGFloat)naviBarContentHeight;
/// NaviBar 的高度, 已适配iPhone X
+ (CGFloat)naviBarHeight;
/// TabBar内容高度
+ (CGFloat)tabBarContentHeight;
/// TabBar 高度, 已适配iPhone X
+ (CGFloat)tabBarHeight;

#pragma mark - 系统判断
+ (BOOL)iOSSystem:(CGFloat)system;
/// iOS 8 判断
+ (BOOL)isIOS8Later;
/// iOS 9 判断
+ (BOOL)isIOS9Later;
/// iOS 10 判断
+ (BOOL)isIOS10Later;
/// iOS 11 判断
+ (BOOL)isIOS11Later;
/// iOS 11.2 判断
+ (BOOL)isIOS11_2Later;

#pragma mark - 机型判断
/// iPhoneX 判断
+ (BOOL)isIPHONEX;

@end

NS_ASSUME_NONNULL_END
