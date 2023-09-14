//
//  DSGrayUtil.h
//  DSGrayViewKit
//
//  Created by zhuyuhui on 2021/11/8.
//

#import <Foundation/Foundation.h>
#import "DSGrayManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSGrayUtil : NSObject

/// 获取RGBA的灰度值
/// @param r Red
/// @param g Green
/// @param b Blue
/// @param a Alpha
+ (UIColor *)grayColorFroRed:(CGFloat)r
                       green:(CGFloat)g
                        blue:(CGFloat)b
                       alpha:(CGFloat)a;

/// 获取颜色的灰度颜色
/// @param colorRef CGColorRef
+ (UIColor *)grayColorForCGColor:(CGColorRef)colorRef;

/// 获取颜色的灰度颜色
/// @param color UIColor
+ (UIColor *)grayColorForUIColor:(UIColor *)color;

/// 获取图片的灰度图片
/// @param image UIImage
+ (UIImage *)grayImageForUIImage:(UIImage *)image;

/// 方法替换
/// @param oriSel 被替换的SEL
/// @param oriMethod 被替换的Mehod
/// @param swizzledSel 替换的SEL
/// @param swizzledMethod 替换的Method
/// @param cls 被替换的Class
+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                          oriClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
