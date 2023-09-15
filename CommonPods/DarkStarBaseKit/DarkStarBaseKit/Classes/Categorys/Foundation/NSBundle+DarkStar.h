//
//  NSBundle+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (DarkStar)

/// 获取Pod库中的指定NSBundle（Pod库中可能存在多个.bundle文件）
/// @param bundleName bundle名
/// @param podName pod名
+ (nullable NSBundle *)ds_bundleName:(NSString *)bundleName inPod:(NSString *)podName;

/// 获取指定bundle中的图片
/// @param name 图片名
/// @param bundle bundle
+ (nullable UIImage *)ds_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;


+ (NSArray *)preferredScales;

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath;

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext;

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

@end

NS_ASSUME_NONNULL_END
